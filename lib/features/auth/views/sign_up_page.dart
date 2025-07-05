import 'package:chat_app/components/i_text_form_field.dart';
import 'package:chat_app/components/logo.dart';
import 'package:chat_app/components/welcome_message.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final confirmPasswordFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    confirmPasswordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = parseError(error);
          showErrorSnackbar(context, message);
        },
      );
    });
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
                    const MyLogo(),
                    const SizedBox(height: 16),
                    const WelcomeMessage(),
                    const SizedBox(height: 32),
                    Expanded(child: SingleChildScrollView(child: _buildForm())),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => context.go("/signin"),
                    child: const Text("Sign In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
              validator: valiatedEmail,
            ),
            const SizedBox(height: 16),
            const Text("Password"),
            const SizedBox(height: 8),
            ITextFormField(
              controller: passwordFieldController,
              obscure: true,
              validator: validatePassword,
            ),
            const SizedBox(height: 16),
            const Text("Confirm Password"),
            const SizedBox(height: 8),
            ITextFormField(
              controller: confirmPasswordFieldController,
              obscure: true,
              validator: (String? password) => validateConfirmPassword(
                password,
                passwordFieldController.text,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: ref.watch(authViewModelProvider).isLoading
                      ? null
                      : _submitForm,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 20.0,
                    ),
                    child: Text("Sign Up"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      try {
        await ref
            .read(authViewModelProvider.notifier)
            .signUp(emailFieldController.text, passwordFieldController.text);
        if (mounted) {
          context.replace("/");
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }
}
