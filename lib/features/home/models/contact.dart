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
  }) = _Contact;

  factory Contact.fromUserDocument(String uid, Map<String, dynamic> data) =>
      Contact(uid: uid, email: data["email"], displayName: data["displayName"]);
}
