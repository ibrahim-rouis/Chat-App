import 'package:chat_app/components/decorated_body.dart';
import 'package:chat_app/components/my_app_bar.dart';
import 'package:chat_app/features/home/models/contact.dart';
import 'package:chat_app/features/home/models/message.dart';
import 'package:chat_app/features/home/viewmodels/contacts_viewmodel.dart';
import 'package:chat_app/features/home/viewmodels/messages_viewmodel.dart';
import 'package:chat_app/features/home/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key, required this.contactUid});

  final String contactUid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessagingPageState();
}

class _MessagingPageState extends ConsumerState<MessagesPage> {
  late final Contact? contact;

  @override
  void initState() {
    super.initState();
    contact = ref
        .read(contactsViewModelProvider)
        .valueOrNull
        ?.where((contact) => contact.uid == widget.contactUid)
        .first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: DecoratedBody(child: _buildBody()),
    );
  }

  AppBar _buildAppBar() {
    final th = Theme.of(context);
    return AppBar(
      backgroundColor: th.colorScheme.primary,
      foregroundColor: th.colorScheme.onPrimary,
      title: _buildTitle(),
    );
  }

  Widget _buildBody() {
    return Column(children: [Expanded(child: _buildMessages())]);
  }

  Widget _buildMessages() {
    final messages = ref.watch(messagesViewModelProvider(widget.contactUid));

    return switch (messages) {
      AsyncData(:final value) => _buildMessagesListView(value),
      AsyncError(:final error) => _buildError(error),
      _ => const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      ),
    };
  }

  Center _buildError(Object error) {
    final messages = ref.watch(messagesViewModelProvider(widget.contactUid));
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Text('$error'),
          ElevatedButton(
            onPressed: messages.isLoading ? null : () => _refresh(),
            child: messages.isLoading
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

  void _refresh() {
    // TODO: refresh messages in case of error
    return;
  }

  Widget _buildMessagesListView(List<Message> messages) {
    if (messages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No messages yet :("),
            Text(" Send a message to start conversation."),
          ],
        ),
      );
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text("index: $index");
      },
      itemCount: messages.length,
    );
  }

  Widget _buildTitle() {
    final th = Theme.of(context);

    return Row(
      spacing: 16,
      children: [
        UserAvatar(contact: contact!),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contact!.displayName, style: th.primaryTextTheme.titleLarge),
            Text(contact!.email, style: th.primaryTextTheme.titleSmall),
          ],
        ),
      ],
    );
  }
}
