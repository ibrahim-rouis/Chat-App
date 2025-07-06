import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'demo-api-key',
      appId: '1:1234567890:android:demoappid',
      messagingSenderId: '1234567890',
      projectId: 'demo-dev',
    );
  }
}
