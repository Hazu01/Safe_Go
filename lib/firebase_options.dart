 
 
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

 
 
 
 
 
 
 
 
 
 
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBUh_jP19U9r2pZDBVCUjUkoZiiWQl5NF4',
    appId: '1:824254253366:web:2fc7ab69863c62da9dcb97',
    messagingSenderId: '824254253366',
    projectId: 'safe-go-583fa',
    authDomain: 'safe-go-583fa.firebaseapp.com',
    storageBucket: 'safe-go-583fa.firebasestorage.app',
    measurementId: 'G-3RYRQR9QNT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtsOAsGlQ_-rboJFRIKPah6iB8X8ngCi4',
    appId: '1:824254253366:android:2a7251e2ea50006e9dcb97',
    messagingSenderId: '824254253366',
    projectId: 'safe-go-583fa',
    storageBucket: 'safe-go-583fa.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCh6NFN64c4NEiwxxqEVOs101VPqVuDtHM',
    appId: '1:824254253366:ios:617638d4f68e13629dcb97',
    messagingSenderId: '824254253366',
    projectId: 'safe-go-583fa',
    storageBucket: 'safe-go-583fa.firebasestorage.app',
    iosBundleId: 'com.example.safeGo',
  );
}
