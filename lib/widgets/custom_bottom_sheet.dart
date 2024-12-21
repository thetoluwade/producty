import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showHandle;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? height;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showHandle = true,
    this.padding,
    this.backgroundColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.02),
            offset: const Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Padding(
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showHandle = true,
    EdgeInsets? padding,
    Color? backgroundColor,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CustomBottomSheet(
          title: title,
          showHandle: showHandle,
          padding: padding,
          backgroundColor: backgroundColor,
          height: height,
          child: child,
        ),
      ),
    );
  }
}
