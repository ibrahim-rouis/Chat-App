import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authWatch = ref.watch(authViewModelProvider);

    if (authWatch.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.replace("/");
      });
    }

    return Scaffold(
      body: Center(
        child: switch (authWatch) {
          AsyncError() => Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Oops, something unexpected happened!\nMake sure you are conencted to the internet.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authViewModelProvider.notifier).retry();
                  },
                  child: SizedBox(
                    height: 25,
                    child: authWatch.isRefreshing
                        ? const SizedBox(
                            width: 25,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Refresh"),
                  ),
                ),
              ],
            ),
          ),
          _ => const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        },
      ),
    );
  }
}
