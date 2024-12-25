import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final String? error;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final IconData? icon;
  final int? maxLines;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? textColor;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.error,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.icon,
    this.maxLines = 1,
    this.onTap,
    this.focusNode,
    this.fillColor,
    this.textColor,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultFillColor = isDark ? AppColors.darkGrey : AppColors.white;
    final defaultTextColor = isDark ? AppColors.darkText : AppColors.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: fillColor ?? defaultFillColor,
            borderRadius: BorderRadius.circular(12),
            border: error != null
                ? Border.all(
                    color: isDark ? AppColors.darkError : AppColors.error,
                    width: 1,
                  )
                : null,
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            onTap: onTap,
            onChanged: onChanged,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: textColor ?? defaultTextColor,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.dmSans(
                fontSize: 16,
                color: (textColor ?? defaultTextColor).withOpacity(0.5),
              ),
              prefixIcon: icon != null
                  ? Icon(
                      icon,
                      color: error != null
                          ? (isDark ? AppColors.darkError : AppColors.error)
                          : (textColor ?? defaultTextColor).withOpacity(0.5),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error!,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: isDark ? AppColors.darkError : AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
