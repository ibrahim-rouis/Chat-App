import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

/// UserModel for authenticated user provider
///
/// Called UserModel instead of User to avoid conflict with User class from firebase_auth package
///
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String? email,
    required String? displayName,
  }) = _UserModel;

  factory UserModel.fromUser(User user) => UserModel(
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
  );
}
