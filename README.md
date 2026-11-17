# DonnyBoy pro Android

Autor úprav: **NQLSH**. Android 10 a novější. Fork [qUnleashed](https://github.com/DarkFlippers/qUnleashed), původní autoři a GPL-3.0 zůstávají zachovaní. Původní dokumentace je po importu v README.upstream.md.

## Aplikace

- Domovská obrazovka DonnyBoy, vstup do BLE/USB companion aplikace.
- REPO a WEB otevírají firmware DONNY BOY CZ ve výchozím prohlížeči.
- INFO vysvětluje původ forku a odkazuje na podporu Unleashed.
- Samostatné šedobílé tlačítko Zapnout oznámení žádá systémové oprávnění.
- DONNY BOY CZ je první firmware v nabídce. GitHub Releases se převádějí do instalačního katalogu; jen f7 update TGZ s SHA-256 a očekávanou adresou.
- Zachované funkce qUnleashed: BLE/USB, soubory, archiv, vzdálené ovládání. Funkčnost na fyzickém zařízení vyžaduje ověření.

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
