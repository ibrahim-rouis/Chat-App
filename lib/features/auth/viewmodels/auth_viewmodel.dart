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
    }, onError: (error) => completer.completeError(error));

    try {
      final User? user = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException(
          "Could not load athentication state from Firebase",
        ),
      );
      return user;
    } finally {
      sub.cancel();
    }
  }

  /// Retry loading auth state from Firebase in case of error
  Future<void> retry() async {
    ref.invalidateSelf();
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = cred.user != null
          ? AsyncData(UserModel.fromUser(cred.user!))
          : const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // Sign up with email and password
  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = cred.user != null
          ? AsyncData(UserModel.fromUser(cred.user!))
          : const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
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

  // Sign out
  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _auth.signOut();
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
