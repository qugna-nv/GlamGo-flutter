import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgi_RfCKNxmM9joPxCskJLQV2zCzkuTTA',
    appId: '1:287744855030:android:80b9fec37a3531a57415d7',
    messagingSenderId: '287744855030',
    projectId: 'glamgo-4cb97',
    storageBucket: 'glamgo-4cb97.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgi_RfCKNxmM9joPxCskJLQV2zCzkuTTA',
    appId: '1:287744855030:android:80b9fec37a3531a57415d7',
    messagingSenderId: '287744855030',
    projectId: 'glamgo-4cb97',
    storageBucket: 'glamgo-4cb97.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );
}
