import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'icons/cf_icons.dart';

/// Labeled text field.
///
/// Label rendered as Inter w700 13 mutedLabel above a fieldBg r12 container
/// with hairline cardBorder and focus ring (primary 1.5 px).
/// When [obscure] is true an eye-toggle suffix is shown.
class CfInput extends StatefulWidget {
  const CfInput({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? hint;

  @override
  State<CfInput> createState() => _CfInputState();
}

class _CfInputState extends State<CfInput> {
  late bool _hidden;

  @override
  void initState() {
    super.initState();
    _hidden = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedLabel,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: _hidden,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.inter(fontSize: 16, color: AppColors.text),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.mutedDisabled,
            ),
            filled: true,
            fillColor: AppColors.fieldBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radius),
              borderSide:
                  const BorderSide(color: AppColors.cardBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radius),
              borderSide:
                  const BorderSide(color: AppColors.cardBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radius),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            suffixIcon: widget.obscure
                ? IconButton(
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: CfIcons.eye(
                      size: 20,
                      color: _hidden
                          ? AppColors.mutedDisabled
                          : AppColors.mutedLabel,
                    ),
                    splashRadius: 20,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
