import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/navigation.dart';
import 'license_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, this.devicePage});
  final Widget? devicePage;

  Future<void> _open(BuildContext context, String url) async {
    try {
      if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
        throw StateError('Prohlížeč není dostupný.');
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Odkaz se nepodařilo otevřít.')),
        );
      }
    }
  }

  Future<void> _notifications(BuildContext context) async {
    final status = await Permission.notification.request();
    if (!context.mounted) return;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
      status.isGranted
        ? 'Oznámení jsou povolená. Push nových vydání zatím není nakonfigurovaný.'
        : 'Oznámení nejsou povolená.',
    )));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF101114),
    appBar: AppBar(
      title: const Text('DonnyBoy'),
      actions: [
        IconButton(
          tooltip: 'Nastavení',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => openRoute(context, AppRoute.appSettings),
        ),
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.developer_board, color: Color(0xFFFF9700), size: 88),
            const SizedBox(height: 24),
            const Text('DONNY BOY', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFFFF9700))),
            const Text('Flipper Zero • NQLSH', textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 32),
            if (devicePage != null) FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => devicePage!)),
              icon: const Icon(Icons.bluetooth), label: const Text('Připojit Flipper Zero'),
            ),
            FilledButton(onPressed: () => _open(context, 'https://github.com/luciferbelzebob3-afk/DONNYBOYCZ'), child: const Text('REPO')),
            OutlinedButton(onPressed: () => _open(context, 'https://luciferbelzebob3-afk.github.io/DONNYBOYCZ/'), child: const Text('WEB')),
            OutlinedButton(
              child: const Text('INFO'),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('O aplikaci DonnyBoy'),
                  content: const SingleChildScrollView(child: Text(
                    'Autor úprav: NQLSH\n\n'
                    'DonnyBoy je fork aplikace qUnleashed z repozitáře DarkFlippers/qUnleashed. '
                    'Firmware DONNY BOY CZ vychází z Unleashed.\n\n'
                    'Pokud se ti aplikace nebo firmware líbí, podpoř vývojáře Unleashed. '
                    'Původní autoři a licence GPL-3.0 zůstávají zachovaní.\n\n'
                    'Verze 0.1.0 preview. Oznámení vydání přes Firebase nejsou nakonfigurovaná.',
                  )),
                  actions: [
                    TextButton(onPressed: () => _open(ctx, 'https://flipperunleashed.com/'), child: const Text('Podpořit Unleashed')),
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Zavřít')),
                  ],
                ),
              ),
            ),
            TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const AppLicensePage())), child: const Text('Licence a původní autoři')),
            const SizedBox(height: 48),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
              onPressed: () => _notifications(context),
              child: const Text('Zapnout oznámení'),
            ),
            const Text('Systémové oprávnění pro oznámení. Upozornění na nová vydání budou vyžadovat samostatné nastavení.',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}
