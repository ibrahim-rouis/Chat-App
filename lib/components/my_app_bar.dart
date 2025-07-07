import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    return AppBar(
      backgroundColor: th.colorScheme.primary,
      foregroundColor: th.colorScheme.onPrimary,
      title: const Text("Chat App"),
      actions: [
        Consumer(
          builder: (context, ref, child) => IconButton(
            onPressed: () {
              ref.read(authViewModelProvider.notifier).signOut().then((_) {
                if (!context.mounted) return;
                context.go("/signin");
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
