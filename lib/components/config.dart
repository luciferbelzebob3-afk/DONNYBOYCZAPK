import 'package:flutter/material.dart';

class QAppConfig {
  const QAppConfig._();

  static const firmware = FirmwareConfig(
    firmwares: [
      FirmwareEntry(
        name: 'DONNY BOY CZ',
        shortName: 'donnyboy',
        icon: 'cfw.png',
        matchKeywords: ['donny', 'donnyboy', 'donnyboycz'],
        colors: FirmwareColors(
          primary: Color(0xFFFF9700),
          secondary: Color(0xFFCC5F00),
          tertiary: Color(0xFFFFB347),
        ),
      ),
    ],
  );

  static FirmwareEntry get defaultFirmware => firmware.firmwares.first;
}

class FirmwareColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;

  const FirmwareColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });
}

class FirmwareEntry {
  final String name;
  final String shortName;
  final String icon;
  final List<String> matchKeywords;
  final FirmwareColors colors;

  const FirmwareEntry({
    required this.name,
    required this.shortName,
    required this.icon,
    this.matchKeywords = const [],
    required this.colors,
  });

  String get assetPath => shortName == 'donnyboy'
      ? 'assets/img/donnyboy_icon.png'
      : 'assets/img/firmware/$icon';
}

class FirmwareConfig {
  final List<FirmwareEntry> firmwares;

  const FirmwareConfig({required this.firmwares});

  bool get isSingle => firmwares.length == 1;
}
