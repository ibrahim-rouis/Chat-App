import 'package:flutter/material.dart';

class ITextFormField extends StatelessWidget {
  const ITextFormField({
    super.key,
    this.controller,
    this.obscure = false,
    this.validator,
  });

  final TextEditingController? controller;
  final bool obscure;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
      validator: validator,
    );
  }
}
