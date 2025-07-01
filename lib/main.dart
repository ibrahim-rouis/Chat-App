import 'package:chat_app/routers/app_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    try {
      if (DefaultFirebaseOptions.currentPlatform ==
          DefaultFirebaseOptions.android) {
        FirebaseFirestore.instance.useFirestoreEmulator("10.0.2.2", 8080);
        await FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9099);
      } else {
        FirebaseFirestore.instance.useFirestoreEmulator("127.0.0.1", 8080);
        await FirebaseAuth.instance.useAuthEmulator("127.0.0.1", 9099);
      }
    } catch (e) {
      debugPrint("Failed to connect to emulators, reason: $e.");
    }
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: "Chat App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
