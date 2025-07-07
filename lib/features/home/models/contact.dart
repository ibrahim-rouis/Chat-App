import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';

/// Contact model for cached user contacts list
///
@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    required String uid,
    required String email,
    required String displayName,
    String? lastMessage,
    DateTime? updatedAt,
  }) = _Contact;

  factory Contact.fromUserDocument(String uid, Map<String, dynamic> data) =>
      Contact(uid: uid, email: data["email"], displayName: data["displayName"]);

  factory Contact.fromUserDocumentWithMeta(
    String uid,
    Map<String, dynamic> data,
    Map<String, dynamic> metadata,
  ) => Contact(
    uid: uid,
    email: data["email"],
    displayName: data["displayName"],
    lastMessage: metadata["lastMessage"],
    updatedAt: (metadata["updatedAt"] as Timestamp).toDate(),
  );
}
