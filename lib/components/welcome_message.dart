import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
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
}
