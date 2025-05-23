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
    apiKey: 'AIzaSyAY94wfQvmJUKC1VsbjG45g93a6By2EjUY',
    appId: '1:385392350212:web:00eee47b3c8809b9559151',
    messagingSenderId: '385392350212',
    projectId: 'glucureplus',
    authDomain: 'glucureplus.firebaseapp.com',
    storageBucket: 'glucureplus.firebasestorage.app',
    measurementId: 'G-M44GRN5WX9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwoNQlFBL_jU1oFDuaiNHf_S-6Bx6IbiA',
    appId: '1:385392350212:android:7c34c83cb9c1afab559151',
    messagingSenderId: '385392350212',
    projectId: 'glucureplus',
    storageBucket: 'glucureplus.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNVpZe5ZbzkyLcYMSkCe2cKdWIVet07lM',
    appId: '1:385392350212:ios:37f20e8f6292f11a559151',
    messagingSenderId: '385392350212',
    projectId: 'glucureplus',
    storageBucket: 'glucureplus.firebasestorage.app',
    iosBundleId: 'com.example.glucurePlus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNVpZe5ZbzkyLcYMSkCe2cKdWIVet07lM',
    appId: '1:385392350212:ios:37f20e8f6292f11a559151',
    messagingSenderId: '385392350212',
    projectId: 'glucureplus',
    storageBucket: 'glucureplus.firebasestorage.app',
    iosBundleId: 'com.example.glucurePlus',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAY94wfQvmJUKC1VsbjG45g93a6By2EjUY',
    appId: '1:385392350212:web:eee12e916f2661f1559151',
    messagingSenderId: '385392350212',
    projectId: 'glucureplus',
    authDomain: 'glucureplus.firebaseapp.com',
    storageBucket: 'glucureplus.firebasestorage.app',
    measurementId: 'G-6J2C2CZ81Q',
  );
}
