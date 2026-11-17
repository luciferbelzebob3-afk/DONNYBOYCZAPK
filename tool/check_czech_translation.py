#!/usr/bin/env python3
"""Validate Czech coverage, ICU arguments/branches and Android widget strings.

Run without Flutter: python3 tool/check_czech_translation.py
This checks resources, not compilation or device rendering.
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"Duplicate JSON key: {key}")
        result[key] = value
    return result


def read_arb(locale):
    path = ROOT / 'translations' / f'app_{locale}.arb'
    data = json.loads(path.read_text(encoding='utf-8'), object_pairs_hook=unique_object)
    assert data['@@locale'] == locale, path
    return {key: value for key, value in data.items() if not key.startswith('@')}


class Message:
    """Resource syntax validator for the simple and plural ICU forms used here."""

    def __init__(self, source):
        self.source = source
        self.index = 0
        self.arguments = set()
        self.plurals = []

    def token(self, pattern):
        self.space()
        match = re.match(pattern, self.source[self.index:])
        assert match, f'Expected {pattern} at {self.index}'
        self.index += len(match[0])
        return match[0]

    def space(self):
        while self.index < len(self.source) and self.source[self.index].isspace():
            self.index += 1

    def expect(self, char):
        self.space()
        assert self.source[self.index:self.index + 1] == char, f'Expected {char} at {self.index}'
        self.index += 1

    def parse(self, nested=False):
        while self.index < len(self.source):
            char = self.source[self.index]
            if char == "'":
                # use-escaping: true: doubled apostrophes or quoted literals.
                self.index += 1
                if self.source[self.index:self.index + 1] == "'":
                    self.index += 1
                    continue
                while self.index < len(self.source):
                    if self.source[self.index] == "'":
                        self.index += 1
                        if self.source[self.index:self.index + 1] == "'":
                            self.index += 1
                            continue
                        break
                    self.index += 1
                else:
                    raise ValueError('Unclosed quoted ICU literal')
            elif char == '{':
                self.index += 1
                argument = self.token(r'[A-Za-z_][A-Za-z_0-9]*')
                self.arguments.add(argument)
                self.space()
                if self.source[self.index:self.index + 1] == '}':
                    self.index += 1
                    continue
                self.expect(',')
                kind = self.token(r'[a-z]+')
                assert kind in ('plural', 'select', 'selectordinal'), kind
                self.expect(',')
                branches = set()
                while True:
                    self.space()
                    if self.source[self.index:self.index + 1] == '}':
                        self.index += 1
                        break
                    selector = self.token(r'=-?[0-9]+|[a-zA-Z_][A-Za-z_0-9]*')
                    assert selector not in branches, f'Duplicate ICU selector {selector}'
                    branches.add(selector)
                    self.expect('{')
                    self.parse(nested=True)
                assert 'other' in branches, 'ICU branch other is required'
                self.plurals.append((argument, kind, branches))
            elif char == '}':
                assert nested, 'Unexpected closing brace'
                self.index += 1
                return
            else:
                self.index += 1
        assert not nested, 'Unclosed ICU branch'


def main():
    english, czech = read_arb('en'), read_arb('cs')
    assert english.keys() == czech.keys(), {
        'missing': sorted(english.keys() - czech.keys()),
        'extra': sorted(czech.keys() - english.keys()),
    }
    assert czech['languageName'] == 'Čeština'
    assert czech['appTitle'] == 'DonnyBoy'
    count = 0
    for key, value in czech.items():
        assert isinstance(value, str) and value.strip(), f'Empty/non-string: {key}'
        try:
            source, target = Message(english[key]), Message(value)
            source.parse()
            target.parse()
            assert source.arguments == target.arguments, (source.arguments, target.arguments)
            assert len(source.plurals) == len(target.plurals), 'Missing ICU expression'
            for src, dst in zip(source.plurals, target.plurals):
                assert src[:2] == dst[:2], 'Changed ICU argument or type'
                assert src[2] <= dst[2], 'Dropped ICU selector'
                if dst[1] == 'plural':
                    assert {'one', 'few', 'other'} <= dst[2], 'Missing Czech plural form'
                    count += 1
        except (AssertionError, ValueError, IndexError) as error:
            raise AssertionError(f'{key}: {error}') from error
    shared = sum(czech[key] == english[key] for key in czech)
    assert shared / len(czech) < 0.1, 'Unexpected English fallback content'
    widget = [key for key in czech if key.startswith('androidWidget')]
    assert len(widget) == 10
    print(f'OK: {len(czech)} Czech strings; all ICU arguments preserved; '
          f'{count} Czech plurals; {len(widget)} Android widget strings; '
          f'{shared} shared technical names/units.')


if __name__ == '__main__':
    main()
