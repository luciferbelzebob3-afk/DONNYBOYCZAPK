import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qunleashed/services/localization/controller.dart';
import 'package:qunleashed/services/localization/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Czech contains every source key without English fallbacks', () {
    Map<String, dynamic> strings(String locale) {
      final data = jsonDecode(
        File('translations/app_$locale.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      return Map.fromEntries(data.entries.where((e) => !e.key.startsWith('@')));
    }

    expect(strings('cs').keys.toSet(), strings('en').keys.toSet());
  });

  test('generated Czech uses one, few and other forms', () async {
    final cs = await L10n.delegate.load(const Locale('cs'));
    expect(cs.fmDeleteMany(1), 'Smazat 1 položku?');
    expect(cs.fmDeleteMany(3), 'Smazat 3 položky?');
    expect(cs.fmDeleteMany(5), 'Smazat 5 položek?');
    expect(cs.fmDeleteMany(0), 'Smazat 0 položek?');
    expect(cs.languageName, 'Čeština');
  });

  test('fresh installation defaults to Czech', () async {
    await QLocaleController.instance.loadLocale();
    expect(QLocaleController.instance.locale, const Locale('cs'));
  });

  test('an explicitly saved language is respected', () async {
    SharedPreferences.setMockInitialValues({'locale.code': 'en'});
    await QLocaleController.instance.loadLocale();
    expect(QLocaleController.instance.locale, const Locale('en'));
  });

  test('following the system survives loading preferences again', () async {
    await QLocaleController.instance.setLocale(const Locale('cs'));
    await QLocaleController.instance.setLocale(null);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('locale.code'), 'system');
    await QLocaleController.instance.loadLocale();
    expect(QLocaleController.instance.followsSystem, isTrue);
  });
}
