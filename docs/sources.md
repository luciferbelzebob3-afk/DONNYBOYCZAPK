# Přehled dodaných zdrojů

Ověřeno přes metadata GitHubu 17. 11. 2026. Metadata a licence nejsou audit funkčnosti ani bezpečnosti. Z těchto projektů se kromě výslovně uvedeného základu nekopíruje zdrojový kód.

Základ: [DarkFlippers/qUnleashed](https://github.com/DarkFlippers/qUnleashed), GPL-3.0, commit 388331c619fabe01a19a4149d58b72d2888f722b. Jeho BLE/USB, archiv a instalační workflow se zachovává. Licence zůstává v importovaném LICENSE.

| Zdroj | Licence z API | Rozhodnutí |
|---|---|---|
| [BetterAndroid/android-app-template](https://github.com/BetterAndroid/android-app-template) | Apache-2.0 | Kotlin šablona; nepoužita kvůli Flutter základu. |
| [cortinico/kotlin-android-template](https://github.com/cortinico/kotlin-android-template) | MIT | Kotlin CI inspirace; nepřevzat kód. |
| [liquidpixelbearing/Zennodroid-Automation-Tool](https://github.com/liquidpixelbearing/Zennodroid-Automation-Tool) | Nedoložená | Nedoložená licence; kód nepřebírat. |
| [ashtanko/compose-android-template](https://github.com/ashtanko/compose-android-template) | MIT | Compose šablona; nepoužita. |
| [Tarek-Bohdima/ConsultMe](https://github.com/Tarek-Bohdima/ConsultMe) | MIT | Compose bootstrap; nepoužit. |
| [afkT/DevAICode-Android](https://github.com/afkT/DevAICode-Android) | Apache-2.0 | Inspirace pro instrukce vývoje; nepřevzat kód. |
| [shamil-RS/Android-Architecture-Template](https://github.com/shamil-RS/Android-Architecture-Template) | Nedoložená | Nedoložená licence; kód nepřebírat. |
| [ReVanced/aapt2](https://github.com/ReVanced/aapt2) | GPL-3.0 | Samostatný aapt2 není potřeba; dodává Android SDK. |
| [com-lihaoyi/mill](https://github.com/com-lihaoyi/mill) | MIT | Mill nepřidávat vedle Flutter/Gradle. |
| [expo/eas-cli](https://github.com/expo/eas-cli) | MIT | EAS není potřeba pro Flutter; bez nové placené služby. |
| [h-mdm/hmdm-server](https://github.com/h-mdm/hmdm-server) | Apache-2.0 | MDM server není potřeba pro companion aplikaci. |
| [SpecialCyCi/AndroidSmartUpdates](https://github.com/SpecialCyCi/AndroidSmartUpdates) | MIT | Delta aktualizace nejsou v první verzi potřeba. |
| [NDMAC/apk-updater](https://github.com/NDMAC/apk-updater) | Apache-2.0 | Vlastní updater server není potřeba; GitHub Releases. |
| [GH0ST3CH/BLE-Hound](https://github.com/GH0ST3CH/BLE-Hound) | MIT | Relevantní jen BLE discovery; žádné spam funkce nepřebírat. |
| [DigijEth/FlipperDroid](https://github.com/DigijEth/FlipperDroid) | Nedoložená | Root/kernel modul není součást zadání; bez doložené licence. |
| [naserhajipour/phone-flipper](https://github.com/naserhajipour/phone-flipper) | Nedoložená | Externí rádio není pro standardní Flipper BLE potřeba. |
| [Wyl-cmd/Flipper-Android-Agent](https://github.com/Wyl-cmd/Flipper-Android-Agent) | MIT | Jiný Android základ; nepřebírat do Flutter architektury. |
| [JonBarson/Flipnotify](https://github.com/JonBarson/Flipnotify) | Nedoložená | Nápad pro oznámení; bez doložené licence nepřebírat kód. |

Marketplace odkazy https://github.com/marketplace/actions/build-and-release-apk a https://github.com/marketplace/actions/automated-build-android-app-with-github-action jsou dodané tipy, nikoliv použité závislosti. Jejich konkrétní implementace ani licence nebyly ověřené. Používá se vlastní workflow nad actions/checkout, setup-java, upload-artifact a upstream Flutter setupem. Před případným použitím ověř autora, action.yml, licenci a pin SHA.
