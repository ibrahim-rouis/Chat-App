import 'package:flutter/material.dart';

class DecoratedBody extends StatelessWidget {
  const DecoratedBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final th = Theme.of(context);
    return Stack(
      children: [
        /***** Just for decoration ******/
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
        /***** Just for decoration ******/
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
            child: child,
          ),
        ),
      ],
    );
  }
}
