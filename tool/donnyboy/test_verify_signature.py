import unittest
from verify_signature import verify


class SignatureTest(unittest.TestCase):
    def test_numbered_and_sdk_range_signers(self):
        digest = 'ab' * 32
        for prefix in ['Signer #1', 'Signer (minSdkVersion=29, maxSdkVersion=32)']:
            with self.subTest(prefix=prefix):
                self.assertEqual(verify(f'{prefix} certificate SHA-256 digest: {digest}\n', digest), {digest})

    def test_rejects_missing_wrong_or_additional_signer(self):
        digest = 'ab' * 32
        wrong = 'cd' * 32
        good = f'Signer #1 certificate SHA-256 digest: {digest}\n'
        bad = f'Signer #2 certificate SHA-256 digest: {wrong}\n'
        for text in ['', bad, good + bad, f'Source Stamp certificate SHA-256 digest: {digest}\n']:
            with self.subTest(text=text), self.assertRaises(ValueError):
                verify(text, digest)


if __name__ == '__main__':
    unittest.main()
