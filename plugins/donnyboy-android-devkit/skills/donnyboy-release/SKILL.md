---
name: donnyboy-release
description: Použij pro kontrolu, sestavení a vydání APK DonnyBoy v GitHub Actions a pro balení vývojového pluginu.
---

Nejdřív ověř souhlas s buildem a aktuální workflow .github/workflows/donnyboy-android.yml. Prvotní build je schválený zadáním ze 17. 11. 2026; nové zákazy mají přednost. Pracuj na dev, zachovej cizí práci a neprováděj force push.

Bootstrap importuje upstream z pevného SHA a ukládá změny do repozitáře. Zkontroluj importovaný commit a submoduly; všechny vlastní úpravy pak dělej přímo ve zdrojích. Overlay není automatický generátor po prvním importu. Po změně upstreamu znovu ověř patche a licence; nevypínej neúspěšné testy.

Použij Flutter a Java verze z upstreamu, lockfile, flutter analyze, smysluplné testy parseru a release build. Zkontroluj výstup APK včetně libapp.so, podpis apksignerem a SHA256SUMS. Pokud chybí vlastní release keystore, jasně označ vývojový podpis a nevydávej jej jako finální stabilní release; klíč neukládej do Gitu a neslibuj kontinuitu aktualizací.

APK publikuj až po úspěšných kontrolách jako prerelease pro preview. Uveď přesný run URL, commit a asset. Při chybě načti log konkrétního jobu, oprav skutečnou příčinu a znovu zkontroluj.

Plugin bal do ZIPu s jedním kořenem donnyboy-android-devkit obsahujícím plugin.json a skills/. JSON a YAML zkontroluj před uploadem. Uložení na GitHubu není instalace do účtu. K instalaci použij dostupný Plugin Creator s potvrzeným host-uploaded archivem; pokud prostředí archiv neumí předat, otevřeně uveď blokaci.
