// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDLRTlDi-gRaC11KoeV4l5tu-ylIQHUf8g',
    appId: '1:996712058212:web:f0b0e19c3096e6c2d9fe71',
    messagingSenderId: '996712058212',
    projectId: 'anecdotalhq',
    authDomain: 'anecdotalhq.firebaseapp.com',
    storageBucket: 'anecdotalhq.appspot.com',
    measurementId: 'G-MC1SD6XMQM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDO4h1QGKJ12oLyJ-MSJCFuDUTr-R6z0KY',
    appId: '1:996712058212:android:8895d4b7d98c44c4d9fe71',
    messagingSenderId: '996712058212',
    projectId: 'anecdotalhq',
    storageBucket: 'anecdotalhq.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgr7-ngpO0C0P6lIu21Z-BGCaogSD04Xo',
    appId: '1:996712058212:ios:9e1a5b2019c792dbd9fe71',
    messagingSenderId: '996712058212',
    projectId: 'anecdotalhq',
    storageBucket: 'anecdotalhq.appspot.com',
    iosBundleId: 'com.increasedw.anecdotal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgr7-ngpO0C0P6lIu21Z-BGCaogSD04Xo',
    appId: '1:996712058212:ios:76cd23509283ed86d9fe71',
    messagingSenderId: '996712058212',
    projectId: 'anecdotalhq',
    storageBucket: 'anecdotalhq.appspot.com',
    iosBundleId: 'com.example.anecdotal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDLRTlDi-gRaC11KoeV4l5tu-ylIQHUf8g',
    appId: '1:996712058212:web:e0c256f9488edd53d9fe71',
    messagingSenderId: '996712058212',
    projectId: 'anecdotalhq',
    authDomain: 'anecdotalhq.firebaseapp.com',
    storageBucket: 'anecdotalhq.appspot.com',
    measurementId: 'G-N8339BNN1D',
  );

}