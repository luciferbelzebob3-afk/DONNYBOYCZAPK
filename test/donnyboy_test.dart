import 'package:flutter_test/flutter_test.dart';
import 'package:qunleashed/pages/devices/firmware/directory.dart';

void main() {
  Map<String, dynamic> release({String digest = 'sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', String host = 'github.com', bool prerelease = false}) => {
    'tag_name': 'v1.0.5', 'body': 'Nová verze', 'prerelease': prerelease,
    'assets': [{
      'name': 'flipper-z-f7-update-1.0.5.tgz',
      'browser_download_url': 'https://$host/luciferbelzebob3-afk/DONNYBOYCZ/releases/download/v1.0.5/flipper-z-f7-update-1.0.5.tgz',
      'digest': digest,
    }],
  };

  test('Načte balíček a zachová SHA256 pro ověření při instalaci', () {
    final result = DonnyBoyParser.parseReleases([release()]);
    final file = result.channelById('release')!.latest!.files.single;
    expect(file.sha256, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    expect(file.target, 'f7');
  });
  test('Odmítne chybějící kontrolní součet i cizí server', () {
    expect(() => DonnyBoyParser.parseReleases([release(digest: '')]), throwsA(isA<FirmwareDirectoryUnreadable>()));
    expect(() => DonnyBoyParser.parseReleases([release(host: 'example.com')]), throwsA(isA<FirmwareDirectoryUnreadable>()));
  });
  test('Oddělí testovací vydání', () {
    final result = DonnyBoyParser.parseReleases([release(prerelease: true)]);
    expect(result.channelById('release')!.versions, isEmpty);
    expect(result.channelById('development')!.latest!.version, 'v1.0.5');
  });
}
