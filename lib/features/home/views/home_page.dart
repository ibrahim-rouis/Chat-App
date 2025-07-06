import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/home/models/contact.dart';
import 'package:chat_app/features/home/viewmodels/contacts_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = MediaQuery.of(context).size;
    final th = Theme.of(context);

    final contacts = ref.watch(contactsViewModelProvider);

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
              child: switch (contacts) {
                AsyncData(:final value) => _buildBody(context, value),
                AsyncError(:final error) => Center(
                  child: Column(
                    children: [
                      Text('error: $error'),
                      ElevatedButton(
                        onPressed: () => _refresh(ref),
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
                ),
                _ => const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Add new contact",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Contact> contacts) {
    final th = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text("Contacts", style: th.textTheme.titleMedium),
        ),
        Expanded(child: _buildContactsListView(contacts)),
      ],
    );
  }

  void _refresh(WidgetRef ref) {
    ref.read(contactsViewModelProvider.notifier).refresh();
  }

  Widget _buildContactsListView(List<Contact> contacts) {
    return ListView.builder(
      itemBuilder: (context, i) {
        final contact = contacts[i];
        return ListTile(
          title: Text(contact.displayName),
          subtitle: Text(contact.email),
          leading: SizedBox(
            width: 50,
            height: 50,
            child: CircleAvatar(
              child: Center(child: Text(contact.displayName[0].toUpperCase())),
            ),
          ),
        );
      },
      itemCount: contacts.length,
    );
  }
}
