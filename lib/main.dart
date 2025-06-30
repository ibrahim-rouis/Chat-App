import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    await Firebase.initializeApp(demoProjectId: 'demo-dev');
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
      await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
    } catch (e) {
      debugPrint('Failed to connect to emulators, reason: $e');
      exit(1);
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hello, World!'),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('test')
                    .add({'message': 'FlutterFire Firestore working'})
                    .then(
                      (docRef) =>
                          debugPrint('Firestore add document successful'),
                    )
                    .catchError((e) => debugPrint(e));
              },
              child: const Text('Test Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
