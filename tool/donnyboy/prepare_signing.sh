#!/usr/bin/env bash
set -euo pipefail
umask 077
signing_dir="${RUNNER_TEMP:?}/donnyboy-signing"
mkdir -p "$signing_dir" dist
if [[ -n "${DONNYBOY_KEYSTORE_BASE64:-}" ]]; then
  printf '%s' "$DONNYBOY_KEYSTORE_BASE64" | base64 --decode > "$signing_dir/release.jks"
  : "${DONNYBOY_STORE_PASSWORD:?}" "${DONNYBOY_KEY_ALIAS:?}" "${DONNYBOY_KEY_PASSWORD:?}"
else
  # Initial key creation is permitted only for the first official version.
  [[ "$RELEASE_VERSION" == '1.0.0' ]] || { echo 'Chybí trvalý podpisový klíč.' >&2; exit 1; }
  DONNYBOY_STORE_PASSWORD="$(openssl rand -hex 32)"
  DONNYBOY_KEY_PASSWORD="$DONNYBOY_STORE_PASSWORD"
  DONNYBOY_KEY_ALIAS=donnyboy
  export DONNYBOY_STORE_PASSWORD DONNYBOY_KEY_PASSWORD
  keytool -genkeypair -noprompt -storetype JKS \
    -keystore "$signing_dir/release.jks" -alias "$DONNYBOY_KEY_ALIAS" \
    -storepass:env DONNYBOY_STORE_PASSWORD -keypass:env DONNYBOY_KEY_PASSWORD \
    -keyalg RSA -keysize 3072 -validity 10000 \
    -dname 'CN=NQLSH, OU=DonnyBoy, O=DonnyBoy, C=CZ'
fi
printf 'storeFile=%s\nstorePassword=%s\nkeyAlias=%s\nkeyPassword=%s\n' \
  "$signing_dir/release.jks" "$DONNYBOY_STORE_PASSWORD" "$DONNYBOY_KEY_ALIAS" "$DONNYBOY_KEY_PASSWORD" > android/key.properties
# Portable properties travel only inside the encrypted envelope.
printf 'storeFile=release.jks\nstorePassword=%s\nkeyAlias=%s\nkeyPassword=%s\n' \
  "$DONNYBOY_STORE_PASSWORD" "$DONNYBOY_KEY_ALIAS" "$DONNYBOY_KEY_PASSWORD" > "$signing_dir/key.properties"
keytool -exportcert -rfc -keystore "$signing_dir/release.jks" \
  -alias "$DONNYBOY_KEY_ALIAS" -storepass:env DONNYBOY_STORE_PASSWORD > dist/DonnyBoy-signing-certificate.pem
tar -C "$signing_dir" -cf "$signing_dir/signing.tar" release.jks key.properties
openssl cms -encrypt -binary -aes-256-cbc -in "$signing_dir/signing.tar" \
  -outform DER -out dist/DonnyBoy-signing.cms tool/donnyboy/recovery-public.pem
