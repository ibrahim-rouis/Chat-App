import 'package:flutter/material.dart';

class ITextFormField extends StatelessWidget {
  const ITextFormField({
    super.key,
    this.controller,
    this.obscure = false,
    this.validator,
    this.hintText,
  });

  final TextEditingController? controller;
  final bool obscure;
  final String? Function(String?)? validator;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
        hintText: hintText,
      ),
      validator: validator,
    );
  }
}
