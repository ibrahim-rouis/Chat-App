import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/home/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_viewmodel.g.dart';

@riverpod
class MessagesViewModel extends _$MessagesViewModel {
  final _db = FirebaseFirestore.instance;
  final _collection = "messages";

  @override
  Future<List<Message>> build(String contactUID) async {
    final user = ref.watch(authViewModelProvider).valueOrNull;

    if (user == null) {
      throw Exception("You are not logged in");
    }

    var uidsList = <String>[user.uid, contactUID];
    uidsList.sort();
    String uniqueCombinedId = uidsList.join("");

    final query = await _db
        .collection(_collection)
        .doc(uniqueCombinedId)
        .collection("messages")
        .limit(25)
        .get();

    if (query.size == 0) {
      await _db.collection(_collection).doc(uniqueCombinedId).set({});
      return <Message>[];
    }

    final messages = query.docs
        .map((doc) => Message.fromJson(doc.data()))
        .toList();

    return messages;
  }
}
