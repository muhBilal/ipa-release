import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'Platform tidak didukung oleh FirebaseOptions ini.',
        );
    }
  }

  // ===========================
  // ANDROID 
  // ===========================
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCy8qdMsxrbQ52t0Tfiw6trS7rALVWEL6w',
    appId: '1:312211563911:android:091eb96ba17c9c82631f22',
    messagingSenderId: '312211563911',
    projectId: 'nswac-app',
    storageBucket: 'nswac-app.firebasestorage.app',
  );

  // ===========================
  // iOS 
  // ===========================
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCy8qdMsxrbQ52t0Tfiw6trS7rALVWEL6w',
    appId: '1:312211563911:ios:091eb96ba17c9c82631f22',
    messagingSenderId: '312211563911',
    projectId: 'nswac-app',
    storageBucket: 'nswac-app.firebasestorage.app',
    iosBundleId: 'com.ngoerahsunwac.mobile',
  );

  // ===========================
  // WEB 
  // ===========================
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCy8qdMsxrbQ52t0Tfiw6trS7rALVWEL6w',
    appId: '1:312211563911:web:091eb96ba17c9c82631f22',
    messagingSenderId: '312211563911',
    projectId: 'nswac-app',
    storageBucket: 'nswac-app.firebasestorage.app',
  );
}
