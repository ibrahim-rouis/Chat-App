import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hello, World!"),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("test")
                    .add({"message": "FlutterFire Firestore working"})
                    .then(
                      (docRef) =>
                          debugPrint("Firestore add document successful"),
                    )
                    .catchError((e) => debugPrint(e));
              },
              child: const Text("Test Firestore"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(authViewModelProvider.notifier).signOut().then((
                  value,
                ) {
                  if (context.mounted) {
                    context.replace("/signin");
                  }
                });
              },
              child: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
