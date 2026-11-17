// DonnyBoy preview intentionally ships without FCM configuration.
// PushService catches this and reports push as unavailable. Local BLE
// connection notifications use the existing local notification service.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();
  static FirebaseOptions get currentPlatform =>
      throw UnsupportedError('DonnyBoy preview: push není nakonfigurovaný.');
}
