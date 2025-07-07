import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/home/models/message.dart';
import 'package:chat_app/features/home/viewmodels/contacts_viewmodel.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_viewmodel.g.dart';

@riverpod
class MessagesViewModel extends _$MessagesViewModel {
  final _db = FirebaseFirestore.instance;
  final _collection = "messages";

  @override
  Stream<List<Message>> build(String contactUID) {
    final user = ref.watch(authViewModelProvider).valueOrNull;

    if (user == null) return const Stream.empty();

    String uniqueCombinedId = getUniqueID(user.uid, contactUID);

    return _db
        .collection("messages")
        .doc(uniqueCombinedId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            debugPrint(doc.data().toString());
            return Message.fromJson(doc.data());
          }).toList();
        });
  }

  void refresh() {
    ref.invalidateSelf();
  }

  Future<void> sendMessageTo(String contactUID, String message) async {
    final user = ref.read(authViewModelProvider).valueOrNull;

    if (user == null) {
      throw Exception("You are not logged in");
    }
    String uniqueCombinedId = getUniqueID(user.uid, contactUID);
    await _db
        .collection(_collection)
        .doc(uniqueCombinedId)
        .collection("messages")
        .add({
          "senderUID": user.uid,
          "content": message,
          "timestamp": FieldValue.serverTimestamp(),
        });

    await _db.collection(_collection).doc(uniqueCombinedId).set({
      "lastMessage": message,
      "lastSender": user.uid,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    ref.invalidate(contactsViewModelProvider);
  }
}
