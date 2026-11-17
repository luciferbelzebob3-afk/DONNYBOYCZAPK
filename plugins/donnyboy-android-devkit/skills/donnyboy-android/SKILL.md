---
name: donnyboy-android
description: Použij při vývoji Android aplikace DonnyBoy, obrazovek, oprávnění a BLE či USB propojení s Flipper Zero.
---

Pracuj v luciferbelzebob3-afk/DONNYBOYCZAPK na dev. Nejprve načti aktuální zdroje a AGENTS.md. Základem je Flutter qUnleashed; nepřepisuj jej na Kotlin podle nesouvisející šablony. Změny UI patří do lib/pages a kompozice do lib/app. Zachovej balíček Dart qunleashed kvůli interním importům; Android applicationId je cz.nqlsh.donnyboy, jméno DonnyBoy a autor úprav NQLSH.

Domovská obrazovka obsahuje vstup do companion aplikace, INFO dialog, REPO a WEB ve výchozím externím prohlížeči a šedobílé tlačítko Zapnout oznámení. INFO uvádí qUnleashed, Unleashed, původní autory a podporu https://flipperunleashed.com/. Odkazy firmware a webu ber z README. Nové Android texty piš česky s diakritikou.

BLE a USB stav řeš existujícím FlipperClient a DeviceController. Nezaváděj druhé paralelní připojení. Při opravách zkontroluj lib/modules/flipperlib, android manifest, životní cyklus, foreground service a permission center. Nežádej oprávnění při startu bez akce uživatele. Nevyžaduj root. Po zamítnutí nabídni systémové nastavení.

FCM potřebuje vlastní projekt a konfiguraci; nepoužívej konfiguraci upstream autorů ani neuváděj samotné systémové povolení jako funkční push. Aktuální preview FCM neposkytuje. Nová stabilní vydání DONNY BOY CZ sleduje nativní DonnyBoyReleaseJob přes JobScheduler, výhradně po zapnutí uživatelem. Handler donnyboy/releases v MainActivity umí enable/disable. Interval je nejméně 15 minut a může být systémem odložen; první úspěšná kontrola uloží základní verzi. Používá ETag a nevyžaduje placený backend. Zkontroluj oprávnění před zveřejněním oznámení a zachovej možnost vypnutí. Zachovej lokalní oznámení BLE služby. Pro fyzické testování ověř Android 10 a 13+, připojení, odpojení, background/reconnect a odmítnutí oprávnění. Nehlaš test, který neproběhl.

Zdroje a jejich omezení jsou v ../../references/sources.md. Nepřebírej kód z projektů bez doložené licence.
