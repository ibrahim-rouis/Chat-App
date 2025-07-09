import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/home/models/contact.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_viewmodel.g.dart';

@riverpod
class ContactsViewModel extends _$ContactsViewModel {
  final _db = FirebaseFirestore.instance;
  final _collection = "contacts";

  @override
  Future<List<Contact>> build() async {
    final user = ref.watch(authViewModelProvider).valueOrNull;

    if (user == null) {
      return throw Exception("You are not logged in!");
    }

    List<Contact> contacts = <Contact>[];

    final doc = await _db.collection(_collection).doc(user.uid).get();

    if (!doc.exists) {
      await _db.collection(_collection).doc(user.uid).set({"contacts": []});
      return contacts;
    }

    // every document in contacts collection has id of owner's uid and a 'contacts' field with a list of contacts uids
    final contactsUIDs = doc.data()!["contacts"];

    for (final uid in contactsUIDs) {
      final contact = await _getContactInfoByUID(uid, user.uid);
      if (contact != null) contacts.add(contact);
    }

    // null first sort
    contacts.sort(
      (a, b) => a.updatedAt == null
          ? 1
          : b.updatedAt == null
          ? -1
          : a.updatedAt!.compareTo(b.updatedAt!),
    );

    return contacts;
  }

  void refresh() {
    ref.invalidateSelf();
  }

  Future<Contact?> _getContactInfoByUID(
    String uid,
    String currentUserUid,
  ) async {
    final doc = await _db.collection("users").doc(uid).get();
    final metaDoc = await _db
        .collection("messages")
        .doc(getUniqueID(currentUserUid, uid))
        .get();

    if (!doc.exists) return null;

    if (metaDoc.exists) {
      return Contact.fromUserDocumentWithMeta(
        doc.id,
        doc.data()!,
        metaDoc.data()!,
      );
    } else {
      return Contact.fromUserDocument(doc.id, doc.data()!);
    }
  }

  Future<Contact?> _findUserByEmail(String email) async {
    final query = await _db
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    final doc = query.docs.first;

    return Contact.fromUserDocument(doc.id, doc.data());
  }

  Future<void> addUserToContacts(String email) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(authViewModelProvider).valueOrNull;

      if (user == null) {
        throw Exception("You are not logged in!");
      }

      final newContact = await _findUserByEmail(email);

      if (newContact == null) {
        throw Exception("Contact with given email not found");
      }

      if (user.uid == newContact.uid) {
        throw Exception("You cannot add yourself");
      }

      // // Check if UID exists
      // final doc = await _db.collection("users").doc(newContact.uid).get();
      // if (!doc.exists) {
      //   throw Exception(
      //     "User uid ${newContact.uid} not found in users collection",
      //   );
      // }

      await _db.collection(_collection).doc(user.uid).update({
        "contacts": FieldValue.arrayUnion([newContact.uid]),
      });
      await _db.collection(_collection).doc(newContact.uid).update({
        "contacts": FieldValue.arrayUnion([user.uid]),
      });

      // final otherDoc = await _db
      //     .collection(_collection)
      //     .doc(newContact.uid)
      //     .get();
      // if (!otherDoc.exists) {
      //   await _db.collection(_collection).doc(newContact.uid).set({
      //     "contacts": [],
      //   });
      // }

      // refresh contacts
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
