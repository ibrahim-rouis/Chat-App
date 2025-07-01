import 'package:chat_app/components/i_text_form_field.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 64),
                    _buildLogo(th),
                    const SizedBox(height: 16),
                    _buildWelcomeMessage(th),
                    const SizedBox(height: 32),
                    Expanded(child: SingleChildScrollView(child: _buildForm())),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () => context.go("/signup"),
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildWelcomeMessage(ThemeData th) {
    return Column(
      children: [
        Text("Welcome to Chat App", style: th.textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(
          "Chat with your friends and make chat groups.",
          style: th.textTheme.titleSmall!.copyWith(
            color: th.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Icon _buildLogo(ThemeData th) {
    return Icon(Icons.message, size: 126, color: th.colorScheme.primary);
  }

  Form _buildForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Email"),
            const SizedBox(height: 8),
            ITextFormField(
              controller: emailFieldController,
              validator: _valiatedEmail,
            ),
            const SizedBox(height: 16),
            const Text("Password"),
            const SizedBox(height: 8),
            ITextFormField(
              controller: passwordFieldController,
              obscure: true,
              validator: _validatePassword,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: loading ? null : _submitForm,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 20.0,
                    ),
                    child: Text("Sign in"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _valiatedEmail(String? email) {
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

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters long";
    }

    return null;
  }

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        await ref
            .read(authViewModelProvider.notifier)
            .signIn(emailFieldController.text, passwordFieldController.text);
        if (mounted) {
          context.replace("/");
        }
      } on FirebaseAuthException catch (e) {
        debugPrint("Firebase auth error code: ${e.code}");
        switch (e.code) {
          case "user-not-found":
            _showErrorSnackbar("Email not found");
            break;
          case "wrong-password":
            _showErrorSnackbar("Incorrect Password");
            break;
          default:
            _showErrorSnackbar("Sign in error: ${e.code}");
        }
      } catch (_) {
        _showErrorSnackbar("An unknown error as occured");
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String text) {
    if (mounted) {
      final th = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: th.colorScheme.error,
          content: Text(text, style: TextStyle(color: th.colorScheme.onError)),
        ),
      );
    }
  }
}
