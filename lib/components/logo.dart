import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    return Icon(Icons.message, size: 126, color: th.colorScheme.primary);
  }
}
