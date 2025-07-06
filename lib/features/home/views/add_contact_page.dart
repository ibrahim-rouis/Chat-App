import 'package:chat_app/components/i_text_form_field.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/home/viewmodels/contacts_viewmodel.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddContactPage extends ConsumerStatefulWidget {
  const AddContactPage({super.key});

  @override
  ConsumerState<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends ConsumerState<AddContactPage> {
  final formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(contactsViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = parseError(error);
          showErrorSnackbar(context, message);
        },
      );
    });

    final screen = MediaQuery.of(context).size;
    final th = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: th.colorScheme.primary,
        foregroundColor: th.colorScheme.onPrimary,
        title: const Text("Chat App"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authViewModelProvider.notifier).signOut().then((_) {
                if (!context.mounted) return;
                context.go("/signin");
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          /***** Just for decoration ******/
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: BoxDecoration(color: th.colorScheme.primary),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: BoxDecoration(color: th.colorScheme.surface),
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: th.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                ),
              ),
            ),
          ),
          /***** Just for decoration ******/
          Positioned(
            left: 0,
            right: 0,
            top: 20,
            bottom: 0,
            child: Container(
              width: screen.width,
              decoration: BoxDecoration(
                color: th.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                ),
              ),
              child: _buildForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final th = Theme.of(context);
    final contacts = ref.watch(contactsViewModelProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Type the email address you want to add",
                style: th.textTheme.titleSmall,
              ),
              ITextFormField(
                controller: textEditingController,
                validator: valiatedEmail,
              ),
              ElevatedButton(
                onPressed: contacts.isLoading ? null : _submitForm,
                child: const Text("Add Contact"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      try {
        final contacts = ref.read(contactsViewModelProvider.notifier);
        final email = textEditingController.text;
        final user = await contacts.findUserByEmail(email);
        if (user == null && mounted) {
          showErrorSnackbar(context, "Email not found");
        } else if (user != null) {
          await contacts.addUserToContacts(user.uid);
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }
}
