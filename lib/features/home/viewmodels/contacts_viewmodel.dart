import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/home/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_viewmodel.g.dart';

@riverpod
class ContactsViewModel extends _$ContactsViewModel {
  final _db = FirebaseFirestore.instance;
  final _collection = "contacts";

  @override
  Future<List<Contact>> build() async {
    final user = ref.read(authViewModelProvider).unwrapPrevious().valueOrNull;

    if (user == null) {
      return throw Exception("You are not logged in!");
    }

    List<Contact> contacts = <Contact>[];

    final docRef = await _db.collection(_collection).doc(user.uid).get();

    if (!docRef.exists) {
      await _db.collection(_collection).doc(user.uid).set({"contacts": []});
      return contacts;
    }

    // every document in contacts collection has id of owner uid and a 'contacts' field with a list of contacts uids
    final contactsUIDs = docRef.data()!["contacts"];

    for (final uid in contactsUIDs) {
      final contact = await _getContactInfoByUID(uid);
      if (contact != null) contacts.add(contact);
    }

    return contacts;
  }

  void refresh() {
    ref.invalidateSelf();
  }

  Future<Contact?> _getContactInfoByUID(String uid) async {
    final docRef = await _db.collection("users").doc(uid).get();

    if (!docRef.exists) return null;

    return Contact.fromUserDocument(docRef.id, docRef.data()!);
  }
}
