import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
          apiKey: "AIzaSyDe3FMpiSlydNfKo6o8Nm08mC0wFi_b6ew",
  authDomain: "ioa-documents.firebaseapp.com",
  projectId: "ioa-documents",
  storageBucket: "ioa-documents.appspot.com",
  messagingSenderId: "882379150768",
  appId: "1:882379150768:web:d2cd64522151cfb0793275",
  measurementId: "G-2J351XQ03Q"
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        apiKey: "AIzaSyDe3FMpiSlydNfKo6o8Nm08mC0wFi_b6ew",
  authDomain: "ioa-documents.firebaseapp.com",
  projectId: "ioa-documents",
  storageBucket: "ioa-documents.appspot.com",
  messagingSenderId: "882379150768",
  appId: "1:882379150768:web:d2cd64522151cfb0793275",
  measurementId: "G-2J351XQ03Q"
      );
    } else {
      // Android
      return const FirebaseOptions(
         apiKey: "AIzaSyDe3FMpiSlydNfKo6o8Nm08mC0wFi_b6ew",
  authDomain: "ioa-documents.firebaseapp.com",
  projectId: "ioa-documents",
  storageBucket: "ioa-documents.appspot.com",
  messagingSenderId: "882379150768",
  appId: "1:882379150768:web:d2cd64522151cfb0793275",
  measurementId: "G-2J351XQ03Q"
      );
    }
  }
}
