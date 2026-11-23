import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qunleashed/components/config.dart';
import 'package:qunleashed/pages/devices/controllers/firmware.dart';
import 'package:qunleashed/pages/devices/firmware/directory.dart';
import 'package:qunleashed/pages/devices/firmware/repository.dart';
import 'package:qunleashed/pages/devices/firmware/update_settings.dart';
import 'package:qunleashed/pages/devices/widgets/page_header.dart';
import 'package:qunleashed/theme/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final entry = QAppConfig.defaultFirmware;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    UpdateSettingsStore.instance.reset();
    FirmwareRepository.instance.reset();
    DonnyBoyParser.instance.seedCache(
      DonnyBoyParser.parseReleases([
        {
          'tag_name': 'v1.0.5',
          'body': 'DONNY BOY CZ',
          'assets': [
            {
              'name': 'flipper-z-f7-update-1.0.5.tgz',
              'browser_download_url': 'https://github.com/luciferbelzebob3-afk/DONNYBOYCZ/releases/download/v1.0.5/flipper-z-f7-update-1.0.5.tgz',
              'digest': 'sha256:${List.filled(64, 'a').join()}',
            },
          ],
        },
      ]),
    );
  });

  test('Only DONNY BOY is offered and Custom cannot be selected', () async {
    expect(QAppConfig.firmware.firmwares.map((e) => e.shortName), ['donnyboy']);
    final controller = FirmwareController();
    addTearDown(controller.dispose);
    await Future<void>.delayed(Duration.zero);
    expect(controller.channelsFor(entry).map((c) => c.id), ['release']);
    controller.setChannel(entry, 'custom');
    expect(controller.selectedChannelId(entry), 'release');
  });

  test(
    'A remembered Custom channel migrates to the DonnyBoy release',
    () async {
      await UpdateSettingsStore.instance.remember(
        'donnyboy',
        channelId: 'custom',
      );
      final controller = FirmwareController();
      addTearDown(controller.dispose);
      await Future<void>.delayed(Duration.zero);
      expect(controller.selectedChannelId(entry), 'release');
      DonnyBoyParser.instance.seedCache(const FirmwareDirectory(channels: []));
      FirmwareRepository.instance.directoryChanged();
      expect(controller.channelsFor(entry), isEmpty);
      expect(controller.selectedChannelId(entry), isNot('custom'));
    },
  );

  testWidgets('Dashboard header fits a narrow phone with enlarged text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(Brightness.dark, const Color(0xFFFF9700)),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: const Scaffold(
            body: DevicePageHeader(
              topInset: 0,
              title: 'Flipper Zero',
              subtitle: 'Flipper Zero',
              active: false,
            ),
          ),
        ),
      ),
    );
    expect(find.text('DONNY BOY'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
