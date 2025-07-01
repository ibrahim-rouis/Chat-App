import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/auth/views/sign_in_page.dart';
import 'package:chat_app/features/home/views/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: "/",
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: "/", builder: (context, state) => const Home()),
      GoRoute(path: "/signin", builder: (context, state) => const SignInPage()),
    ],
    redirect: (context, state) {
      final user = ref.read(authViewModelProvider).value;
      if (user == null) {
        return "/signin";
      }

      return null;
    },
  );
}
