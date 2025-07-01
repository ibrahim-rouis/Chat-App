import 'dart:async';

import 'package:chat_app/features/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final _auth = FirebaseAuth.instance;

  @override
  Future<UserModel?> build() async {
    final user = await _waitForAuthReady();
    return user != null ? UserModel.fromUser(user) : null;
  }

  // Fetch user only once
  Future<User?> _waitForAuthReady() async {
    final completer = Completer<User?>();
    final sub = _auth.authStateChanges().listen((user) {
      completer.complete(user);
    }, onError: (error) => completer.complete(null));

    try {
      final User? user = await completer.future;
      return user;
    } finally {
      sub.cancel();
    }
  }

  /// Retry loading auth state from Firebase in case of error
  Future<void> retry() async {
    ref.invalidateSelf();
    await future;
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    state = cred.user != null
        ? AsyncData(UserModel.fromUser(cred.user!))
        : const AsyncData(null);
  }

  // Sign up with email and password
  Future<void> singUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    state = cred.user != null
        ? AsyncData(UserModel.fromUser(cred.user!))
        : const AsyncData(null);
  }

  // set displayName
  Future<void> setDisplayName(String name) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(name);
    }

    final prevState = await future;

    if (prevState != null) {
      state = AsyncData(prevState.copyWith(displayName: name));
    }
  }
}
