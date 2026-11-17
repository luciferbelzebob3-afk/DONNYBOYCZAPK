# DonnyBoy pro Android

Autor úprav: **NQLSH**. Android 10 a novější. Fork [qUnleashed](https://github.com/DarkFlippers/qUnleashed), původní autoři a GPL-3.0 zůstávají zachovaní. Původní dokumentace je po importu v README.upstream.md.

## Aplikace

- Domovská obrazovka DonnyBoy, vstup do BLE/USB companion aplikace.
- REPO a WEB otevírají firmware DONNY BOY CZ ve výchozím prohlížeči.
- INFO vysvětluje původ forku a odkazuje na podporu Unleashed.
- Samostatné šedobílé tlačítko Zapnout oznámení žádá systémové oprávnění.
- DONNY BOY CZ je první firmware v nabídce. GitHub Releases se převádějí do instalačního katalogu; jen f7 update TGZ s SHA-256 a očekávanou adresou.
- Zachované funkce qUnleashed: BLE/USB, soubory, archiv, vzdálené ovládání. Funkčnost na fyzickém zařízení vyžaduje ověření.

## Oficiální verze 1.0.0

Nový černý vzhled s logem DONNY BOY, oranžovými akcenty a ikonou kluka v kapuci. Oficiální workflow **DonnyBoy official release** provede analýzu, testy, sestavení a ověření vlastního release podpisu. Spouští se změnou `tool/donnyboy/release-request.json` nebo ručně. Preview workflow se spouští jen ručně.

Soukromý klíč se neukládá do Gitu. První oficiální běh vytvoří vlastní RSA 3072 certifikát; podpisový balíček exportuje pouze zašifrovaný veřejným obnovovacím certifikátem vlastníka. Další verze vyžadují tentýž JKS v secrets `DONNYBOY_KEYSTORE_BASE64`, `DONNYBOY_STORE_PASSWORD`, `DONNYBOY_KEY_ALIAS` a `DONNYBOY_KEY_PASSWORD`; nový klíč se automaticky nevytváří.

## Sestavení

Větev `dev`. GitHub Actions: **DonnyBoy Android**. Dokončený import uložil kompletní zdrojový strom qUnleashed z pevného commitu `388331c619fabe01a19a4149d58b72d2888f722b`, včetně submodulů. Cizí workflows se neaktivují. Změny se uloží do dev bez force push. Další běhy pracují s uloženými zdroji.

```sh
git clone --branch dev --recurse-submodules https://github.com/luciferbelzebob3-afk/DONNYBOYCZAPK.git
cd DONNYBOYCZAPK
flutter pub get --enforce-lockfile
flutter analyze --no-pub
flutter test --no-pub test/donnyboy_test.dart
flutter build apk --release --build-name=0.1.0 --build-number=1
```

Flutter 3.47.1 a Java 17 podle upstreamu. Běh musí dokončit analýzu, testy a build před vytvořením prerelease. Výsledkem je DonnyBoy-0.1.0-preview.apk a SHA256SUMS.

**Preview používá vývojový podpis**, dokud nejsou připravené vlastní podpisové klíče. Klíče nevkládat do repozitáře. Není určeno pro Google Play; vývojový podpis mezi běhy nemusí zůstat stejný. Nová stabilní vydání firmwaru hlídá po zapnutí nativní Android JobScheduler (nejdřív přibližně po 15 minutách, podle úspory baterie i později). První kontrola uloží současný stav; upozorní na další verzi. Sledování lze vypnout. Firebase ani placený server nejsou potřeba. Upstream FCM přepínače zůstávají nedostupné.

## Vývojový plugin

Zdroj: `plugins/donnyboy-android-devkit/`. Obsahuje skills pro aplikaci, propojení s firmwarem a release. ZIP přikládá úspěšný build. Uložení zdrojů a ZIP není totéž jako instalace pluginu do účtu ChatGPT. Přehled dodaných zdrojů: [docs/sources.md](docs/sources.md).

Firmware: https://github.com/luciferbelzebob3-afk/DONNYBOYCZ  
Web: https://luciferbelzebob3-afk.github.io/DONNYBOYCZ/  
Podpora Unleashed: https://flipperunleashed.com/

## Český překlad ve zdrojích

Větev `dev` obsahuje kompletní český katalog `translations/app_cs.arb` (1 484 položek, včetně názvů mapových stylů a Android widgetů). Nová instalace používá češtinu; výslovně vybraný jazyk i volba podle systému zůstávají zachované. České texty se udržují přímo v tomto forku, bez Crowdin synchronizace. Převzaté názvy produktů, protokolů, datové formáty a obsah načtený z externích zdrojů se nepřekládají.

Kontrola bez Flutteru: `python3 tool/check_czech_translation.py`. Ověřuje úplnost, ICU proměnné a české množné číslo. Testy generovaných textů a ukládání jazyka: `flutter test test/czech_localization_test.dart test/locale_fallback_test.dart`.

Tato aktualizace mění zdroje překladu. Vydání `apk-preview-4` vzniklo před ní a nový překlad ještě neobsahuje. Nový build ani GitHub Actions se při tomto překladovém commitu nespouštějí.
