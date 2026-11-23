import 'package:flutter/material.dart';

import '../../../components/navigation.dart';
import '../../../theme/theme.dart';

/// DonnyBoy dashboard identity; device actions keep the existing controller.
class DevicePageHeader extends StatelessWidget {
  const DevicePageHeader({
    super.key,
    required this.topInset,
    required this.title,
    required this.subtitle,
    required this.active,
    this.dfu = false,
    this.infoEntries = const [],
    this.deviceInfo = const {},
    this.connectionLabel = 'USB',
    this.connectionIcon = Icons.usb_outlined,
    this.onOpenFullInfo,
  });

  final double topInset;
  final String title;
  final String subtitle;
  final bool active;
  final bool dfu;
  final List<MapEntry<String, String>> infoEntries;
  final Map<String, String> deviceInfo;
  final String connectionLabel;
  final IconData connectionIcon;
  final VoidCallback? onOpenFullInfo;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.fromLTRB(20, topInset + 12, 12, 16),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(bottom: BorderSide(color: colors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/img/donnyboy_icon.png',
                width: 46,
                height: 46,
                semanticLabel: 'Donny Boy',
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'DONNY BOY',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 23,
                    letterSpacing: 2,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Informace a oznámení',
                icon: const Icon(Icons.info_outline),
                onPressed: () => openRoute(context, AppRoute.about),
              ),
              IconButton(
                tooltip: 'Nastavení',
                icon: const Icon(Icons.tune_outlined),
                onPressed: () => openRoute(context, AppRoute.appSettings),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'ŘÍDICÍ CENTRUM',
                style: TextStyle(
                  color: colors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              Text(
                active ? '$title · ${dfu ? 'DFU' : connectionLabel}' : title,
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              if (onOpenFullInfo != null)
                TextButton.icon(
                  onPressed: onOpenFullInfo,
                  icon: Icon(connectionIcon, size: 16),
                  label: const Text('Detail zařízení'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
