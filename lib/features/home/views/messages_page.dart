import 'package:chat_app/components/decorated_body.dart';
import 'package:chat_app/components/i_text_form_field.dart';
import 'package:chat_app/features/auth/models/user_model.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
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
  late final UserModel? currentUser;
  final TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    contact = ref
        .read(contactsViewModelProvider)
        .valueOrNull
        ?.where((contact) => contact.uid == widget.contactUid)
        .first;
    currentUser = ref.read(authViewModelProvider).valueOrNull;
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
    return Column(
      children: [
        Expanded(child: _buildMessages()),
        _buildForm(),
      ],
    );
  }

  Widget _buildForm() {
    final th = Theme.of(context);
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: ITextFormField(
                hintText: "Type a message",
                controller: textEditingController,
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: Icon(Icons.send, color: th.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
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
    ref.read(MessagesViewModelProvider(widget.contactUid).notifier).refresh();
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
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return _buildMessage(messages[index]);
      },
      itemCount: messages.length,
    );
  }

  Widget _buildMessage(Message message) {
    final th = Theme.of(context);
    final isMe = message.senderUID == currentUser?.uid;
    return Row(
      key: ObjectKey(message),
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: isMe ? 16 : 0,
              right: isMe ? 0 : 16,
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: isMe
                  ? th.colorScheme.secondaryContainer
                  : th.colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Text(
              message.content,
              style: isMe
                  ? th.textTheme.bodyLarge
                  : th.primaryTextTheme.bodyLarge,
            ),
          ),
        ),
      ],
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

  void _sendMessage() {
    final message = textEditingController.text;

    if (message.isNotEmpty) {
      ref
          .read(messagesViewModelProvider(widget.contactUid).notifier)
          .sendMessageTo(widget.contactUid, message)
          .whenComplete(() {
            textEditingController.clear();
          });
    }
  }
}
