// File generated from the Firebase configuration already used by Lift Log.
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
        return web;
      default:
        throw UnsupportedError('Firebase is not configured for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDr-qBuzYQbnOBquozvub3Op72YprRrpBE',
    appId: '1:136917112051:web:b5ccbe273c3bc7fd11d386',
    messagingSenderId: '136917112051',
    projectId: 'lift-log-2bf4d',
    authDomain: 'lift-log-2bf4d.firebaseapp.com',
    storageBucket: 'lift-log-2bf4d.firebasestorage.app',
    measurementId: 'G-J410VNB2PF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTmaPNRxJfKGBpfGRdn5N9zPKIp9v_2Ds',
    appId: '1:136917112051:android:e3d9f8dd8e13665511d386',
    messagingSenderId: '136917112051',
    projectId: 'lift-log-2bf4d',
    storageBucket: 'lift-log-2bf4d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC34lSA6pMWF625x-SNb4uHU7x26Uu4t0s',
    appId: '1:136917112051:ios:eb29c6110c9c792611d386',
    messagingSenderId: '136917112051',
    projectId: 'lift-log-2bf4d',
    storageBucket: 'lift-log-2bf4d.firebasestorage.app',
    iosClientId:
        '136917112051-2e17866g034954si77qe1sl3rpqrae93.apps.googleusercontent.com',
    iosBundleId: 'com.example.liftLog',
  );

  static const FirebaseOptions windows = web;
}
