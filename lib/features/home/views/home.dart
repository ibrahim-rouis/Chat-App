import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}
