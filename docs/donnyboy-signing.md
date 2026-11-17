# Podepisování DonnyBoy

Oficiální aktualizace musí používat stejný JKS jako první vydání. Novým klíčem nejde nahradit už nainstalovanou aplikaci bez jejího odinstalování.

Soukromý JKS a hesla uchovávám mimo repozitář. V releasu je jen veřejný certifikát a zašifrovaný podpisový balíček `DonnyBoy-signing.cms`. Ten otevře pouze soukromý obnovovací klíč.

## Místní sestavení

Do `android/` patří soukromý `release.jks` a `key.properties`:

```properties
storeFile=release.jks
storePassword=VLASTNI_HESLO
keyAlias=donnyboy
keyPassword=VLASTNI_HESLO
```

Tyhle soubory nepatří do Gitu. Pravidla `.gitignore` je vylučují.

## Další vydání v GitHub Actions

V nastavení repozitáře používám tato Actions secrets:

| Secret | Hodnota |
| --- | --- |
| `DONNYBOY_KEYSTORE_BASE64` | Obsah stejného JKS zakódovaný do Base64 |
| `DONNYBOY_STORE_PASSWORD` | Heslo úložiště |
| `DONNYBOY_KEY_ALIAS` | Alias klíče |
| `DONNYBOY_KEY_PASSWORD` | Heslo klíče |

První vydání 1.0.0 vytvoří vlastní klíč. Další verze bez nakonfigurovaného klíče skončí chybou, aby omylem nevznikl jiný podpis. Existující tagy se nepřepisují.

Verzi zadávám v `tool/donnyboy/release-request.json`, změny v `tool/donnyboy/release-notes.md`. Workflow před vydáním spouští analýzu, testy a release build. Nakonec ověří podpis APK proti veřejnému certifikátu a spočítá SHA-256.

## Obnovení zašifrovaného balíčku

```sh
openssl cms -decrypt -binary -inform DER \
  -in DonnyBoy-signing.cms \
  -inkey recovery-private.pem \
  -out DonnyBoy-signing.tar
```

Uvnitř jsou `release.jks` a `key.properties`. Soukromý obnovovací klíč ani rozbalený obsah nezveřejňuju.
