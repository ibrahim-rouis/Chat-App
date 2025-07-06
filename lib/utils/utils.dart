import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String text) {
  if (context.mounted) {
    final th = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: th.colorScheme.error,
        content: Text(text, style: TextStyle(color: th.colorScheme.onError)),
      ),
    );
  }
}

String? valiatedEmail(String? email) {
  if (email == null || email.isEmpty) {
    return "Email is required";
  }
  if (!RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email)) {
    return "Invalid email address";
  }

  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return "Password is required";
  }
  if (password.length < 6) {
    return "Password must be at least 6 characters long";
  }

  return null;
}

String? validateConfirmPassword(String? password, String? other) {
  final validate = validatePassword(password);
  if (validate != null) {
    return validate;
  }

  if (other == null || other != password) {
    return "Confirm password doesn't match password";
  }

  return null;
}

String parseError(Object e) {
  if (e is FirebaseAuthException) {
    return switch (e.code) {
      "email-already-in-use" => "Email already in use",
      "user-not-found" => "Email not found",
      "wrong-password" => "Incorrect password",
      _ => "Authentication error: ${e.message}",
    };
  } else if (e is Exception) {
    final message = e.toString();
    return message.substring(0, message.length > 100 ? 100 : message.length);
  } else {
    return "An unknown error has occurred";
  }
}
