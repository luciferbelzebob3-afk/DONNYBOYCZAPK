---
name: donnyboy-firmware-feed
description: Použij při propojení DonnyBoy aplikace s vydáními firmwaru DONNY BOY CZ, při stahování a ověřování instalačních balíčků.
---

Ověř luciferbelzebob3-afk/DONNYBOYCZ, větev dev a aktuální releases přes GitHub. Aplikaci upravuj pouze v DONNYBOYCZAPK. DonnyBoyParser v lib/pages/devices/firmware/directory.dart převádí GitHub releases na existující FirmwareDirectory. FirmwareEntry shortName donnyboy musí vybírat tento parser, nikoliv oficiální firmware.

Akceptuj jen ne-draft vydání a očekávané flipper-z-f7-update-*.tgz s HTTPS adresou v přesném repozitáři a platným SHA-256 digestem. Prerelease odděl do development kanálu. Neměň pořadí verzí podle abecedy; GitHub pořadí je vstupem parseru. Při chybě sítě nebo prázdném katalogu ukaž skutečný stav, ne falešnou dostupnou aktualizaci.

RemoteFirmwareSource již provádí ověření checksumu před instalací. Zachovej tuto kontrolu, odlišení lokálního balíčku a instalační stavy. Varianty Unleashed nemapuj automaticky na DonnyBoy. Před instalací ověř kompatibilitu f7, připojení, baterii a rozbalení očekávaného update manifestu.

Testuj stabilní/prerelease kanály, chybějící digest, cizí host, chybný typ odpovědi a skutečný formát GitHub assets. Firmware nebuildi ani neměň bez samostatného zadání. Automatické zálohy nevytvářej.
