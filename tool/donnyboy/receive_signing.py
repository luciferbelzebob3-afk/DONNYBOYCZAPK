#!/usr/bin/env python3
"""Receive a key encrypted solely for this temporary release runner.

Only the public transport certificate and encrypted envelope leave their hosts.
The existing signing certificate must still match the previous release.
"""
import base64
import json
import os
from pathlib import Path
import shlex
import subprocess
import tarfile
import time


def main():
    runner = Path(os.environ['RUNNER_TEMP'])
    destination = runner / 'donnyboy-signing'
    destination.mkdir(mode=0o700, exist_ok=True)
    endpoint = f'repos/{os.environ["GITHUB_REPOSITORY"]}/contents/tool/donnyboy/signing-transfer.json?ref=dev'
    for _ in range(90):
        response = subprocess.run(['gh', 'api', endpoint], capture_output=True)
        if response.returncode == 0:
            raw = json.loads(response.stdout)
            envelope = json.loads(base64.b64decode(raw['content']))
            if (str(envelope.get('run_id')) == os.environ['GITHUB_RUN_ID']
                    and envelope.get('source_commit') == os.environ['GITHUB_SHA']
                    and envelope.get('version') == os.environ['RELEASE_VERSION']):
                break
        time.sleep(10)
    else:
        raise RuntimeError('Nedorazil podpisový balíček pro toto sestavení.')
    encrypted = destination / 'transfer.cms'
    encrypted.write_bytes(base64.b64decode(envelope['encrypted_cms'], validate=True))
    archive = destination / 'transfer.tar'
    subprocess.run(['openssl', 'cms', '-decrypt', '-binary', '-inform', 'DER',
                    '-in', str(encrypted), '-recip', str(runner / 'donnyboy-transfer.pem'),
                    '-inkey', str(runner / 'donnyboy-transfer.key'), '-out', str(archive)], check=True)
    with tarfile.open(archive) as package:
        members = package.getmembers()
        if {member.name for member in members} != {'release.jks', 'key.properties'}:
            raise ValueError('Neočekávaný obsah podpisového balíčku.')
        for member in members:
            if not member.isfile() or member.size > 1024 * 1024:
                raise ValueError('Neplatná položka podpisového balíčku.')
            (destination / member.name).write_bytes(package.extractfile(member).read())
    props = dict(line.split('=', 1) for line in
                 (destination / 'key.properties').read_text().splitlines() if '=' in line)
    names = {'DONNYBOY_STORE_PASSWORD': 'storePassword',
             'DONNYBOY_KEY_PASSWORD': 'keyPassword', 'DONNYBOY_KEY_ALIAS': 'keyAlias'}
    (destination / 'transfer.env').write_text('\n'.join(
        f'export {name}={shlex.quote(props[key])}' for name, key in names.items()) + '\n')
    for file in destination.iterdir():
        file.chmod(0o600)
    props = dict(line.split('=', 1) for line in
                 (destination / 'key.properties').read_text().splitlines() if '=' in line)
    variables = {
        'DONNYBOY_STORE_PASSWORD': props['storePassword'],
        'DONNYBOY_KEY_ALIAS': props['keyAlias'],
        'DONNYBOY_KEY_PASSWORD': props['keyPassword'],
    }
    (destination / 'transfer.env').write_text(''.join(
        f'export {name}={shlex.quote(value)}\n' for name, value in variables.items()))
    print('Přijat zašifrovaný původní podpisový klíč pro toto sestavení.')


if __name__ == '__main__':
    main()
