// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKgBnVO1UzNHTPQtsw6wnQXICqiMqIyL4',
    appId: '1:292956870819:android:aa949028b18949b5b94716',
    messagingSenderId: '292956870819',
    projectId: 'jlogical-utils',
    storageBucket: 'jlogical-utils.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5XbptcCN1FmtVIQhxzy0aIZGCx6ERwmM',
    appId: '1:292956870819:ios:fa89d510080c5155b94716',
    messagingSenderId: '292956870819',
    projectId: 'jlogical-utils',
    storageBucket: 'jlogical-utils.appspot.com',
    iosClientId: '292956870819-1vbr10ecispsodddklkt2vlj6hib1cep.apps.googleusercontent.com',
    iosBundleId: 'com.jlogical.example',
  );
}