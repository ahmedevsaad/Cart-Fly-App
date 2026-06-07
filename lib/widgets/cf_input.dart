import 'package:flutter/material.dart';
import '../theme/app_text.dart';

class CfInput extends StatelessWidget {
  const CfInput({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.body),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
