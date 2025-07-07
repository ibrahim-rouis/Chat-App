import 'package:chat_app/components/decorated_body.dart';
import 'package:chat_app/components/my_app_bar.dart';
import 'package:chat_app/features/home/models/contact.dart';
import 'package:chat_app/features/home/viewmodels/contacts_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsViewModelProvider);

    return Scaffold(
      appBar: const MyAppBar(),
      body: DecoratedBody(
        child: switch (contacts) {
          AsyncData(:final value) => _buildBody(context, value),
          AsyncError(:final error) => _buildError(error),
          _ => _buildLoading(),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go("/add_contact");
        },
        tooltip: "Add new contact",
        child: const Icon(Icons.add),
      ),
    );
  }

  Center _buildLoading() {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Center _buildError(Object error) {
    final contacts = ref.watch(contactsViewModelProvider);
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Text('error: $error'),
          ElevatedButton(
            onPressed: contacts.isLoading ? null : _refresh,
            child: contacts.isLoading
                ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  )
                : const Text("Refresh"),
          ),
        ],
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

  Future<void> _refresh() async {
    ref.read(contactsViewModelProvider.notifier).refresh();
  }

  Widget _buildContactsListView(List<Contact> contacts) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: contacts.isEmpty
          ? _buildNoContacts()
          : ListView.builder(
              itemBuilder: (context, i) {
                final contact = contacts[i];
                return _buildListTile(contact);
              },
              itemCount: contacts.length,
            ),
    );
  }

  ListView _buildNoContacts() {
    return ListView(
      children: const [
        SizedBox(height: 15),
        Text("You have no contacts :(", textAlign: TextAlign.center),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tap the"),
            Icon(Icons.add),
            Text("button to add new contacts"),
          ],
        ),
        SizedBox(height: 5),
        Text("Swipe down to refresh.", textAlign: TextAlign.center),
      ],
    );
  }

  ListTile _buildListTile(Contact contact) {
    return ListTile(
      onTap: () => context.go("/messages/${contact.uid}"),
      title: Text(contact.displayName),
      subtitle: Text(reduceText(text: contact.lastMessage)),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: UserAvatar(contact: contact),
      ),
    );
  }

  String reduceText({String? text, int max = 30}) {
    if (text == null) {
      return "Start conversation";
    }

    if (text.length > max) {
      return "${text.substring(0, max)}...";
    } else {
      return text;
    }
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Center(child: Text(contact.displayName[0].toUpperCase())),
    );
  }
}
