#!/usr/bin/env python3
"""Check every APK signer against the expected release certificate."""
import re
import sys
from pathlib import Path


def verify(text: str, expected: str) -> set[str]:
    # Android build-tools may label signers by number or their SDK range.
    found = set(re.findall(
        r'^Signer (?:#\d+|\([^\r\n]+\)) certificate SHA-256 digest:\s*([0-9a-fA-F]{64})\s*$',
        text, re.MULTILINE,
    ))
    found = {value.lower() for value in found}
    if found != {expected.lower()}:
        raise ValueError(f'Podpis APK nesouhlasí: očekáváno {expected}; nalezeno {sorted(found)}')
    return found


if __name__ == '__main__':
    verify(Path(sys.argv[1]).read_text(), sys.argv[2])
    print('Všechny podpisy APK odpovídají vlastnímu release certifikátu.')
