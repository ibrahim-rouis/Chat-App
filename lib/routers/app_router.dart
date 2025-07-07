import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/auth/views/sign_in_page.dart';
import 'package:chat_app/features/auth/views/sign_up_page.dart';
import 'package:chat_app/features/home/views/add_contact_page.dart';
import 'package:chat_app/features/home/views/home_page.dart';
import 'package:chat_app/features/home/views/loading_page.dart';
import 'package:chat_app/features/home/views/messages_page.dart';
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
      GoRoute(
        path: "/",
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: "/add_contact",
            builder: (context, state) => const AddContactPage(),
          ),
          GoRoute(
            path: "/messages/:contactUid",
            builder: (context, state) =>
                MessagesPage(contactUid: state.pathParameters["contactUid"]!),
          ),
        ],
        redirect: (context, state) {
          final user = ref.read(authViewModelProvider);
          if (user.isLoading && !user.hasValue) {
            return "/loading";
          }
          if (user.hasValue && user.value == null) {
            return "/signin";
          }

          return null;
        },
      ),
      GoRoute(
        path: "/loading",
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(path: "/signin", builder: (context, state) => const SignInPage()),
      GoRoute(path: "/signup", builder: (context, state) => const SignUpPage()),
    ],
  );
}
