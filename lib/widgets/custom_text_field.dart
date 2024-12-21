import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        if (maxLines! > 1)
          Positioned(
            top: 20,
            left: 16,
            child: Icon(
              prefixIcon,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        TextFormField(
          controller: controller,
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A1A),
          ),
          decoration: InputDecoration(
            hintText: labelText,
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: maxLines! > 1
                ? null
                : Icon(
                    prefixIcon,
                    color: Colors.grey[600],
                    size: 20,
                  ),
            filled: true,
            fillColor: fillColor ?? const Color(0xFFF3F3F3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFDEDEDE),
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.only(
              left: maxLines! > 1 ? 48 : 16,
              right: 16,
              top: maxLines! > 1 ? 20 : 0,
              bottom: maxLines! > 1 ? 20 : 0,
            ),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }
}
