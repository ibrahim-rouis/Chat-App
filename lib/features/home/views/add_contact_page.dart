import 'package:chat_app/components/decorated_body.dart';
import 'package:chat_app/components/i_text_form_field.dart';
import 'package:chat_app/components/my_app_bar.dart';
import 'package:chat_app/features/home/viewmodels/contacts_viewmodel.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      appBar: const MyAppBar(),
      body: DecoratedBody(child: _buildForm()),
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
        await contacts.addUserToContacts(email);
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }
}
