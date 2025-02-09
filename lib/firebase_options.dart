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
    apiKey: 'AIzaSyDU8npac-MJ3FH9XuRTXDdbxFCYbrS5D9o',
    appId: '1:14506149119:web:8f22e58d7387b94ee6f8ca',
    messagingSenderId: '14506149119',
    projectId: 'task1-583d1',
    authDomain: 'task1-583d1.firebaseapp.com',
    storageBucket: 'task1-583d1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCw94jHbBY0uKcIzxSdZkekc6FTBX7GCxk',
    appId: '1:14506149119:android:77c268e08eadadcfe6f8ca',
    messagingSenderId: '14506149119',
    projectId: 'task1-583d1',
    storageBucket: 'task1-583d1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAF_dDDbE9SqSrA_CEcJw8Xe5zNG2Q5hsE',
    appId: '1:14506149119:ios:4d151968aa20e349e6f8ca',
    messagingSenderId: '14506149119',
    projectId: 'task1-583d1',
    storageBucket: 'task1-583d1.appspot.com',
    iosBundleId: 'com.example.newTask',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAF_dDDbE9SqSrA_CEcJw8Xe5zNG2Q5hsE',
    appId: '1:14506149119:ios:4d151968aa20e349e6f8ca',
    messagingSenderId: '14506149119',
    projectId: 'task1-583d1',
    storageBucket: 'task1-583d1.appspot.com',
    iosBundleId: 'com.example.newTask',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDU8npac-MJ3FH9XuRTXDdbxFCYbrS5D9o',
    appId: '1:14506149119:web:0ad6ac68f3d60028e6f8ca',
    messagingSenderId: '14506149119',
    projectId: 'task1-583d1',
    authDomain: 'task1-583d1.firebaseapp.com',
    storageBucket: 'task1-583d1.appspot.com',
  );
}
