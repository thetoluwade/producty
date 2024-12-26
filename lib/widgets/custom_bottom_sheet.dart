import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final bool showHandle;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? height;
  final Widget child;

  const CustomBottomSheet({
    super.key,
    this.title,
    this.showHandle = true,
    this.padding,
    this.backgroundColor,
    this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (theme.brightness == Brightness.dark
                ? const Color(0xFF28282A)
                : AppColors.white),
        borderRadius: BorderRadius.circular(35),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF3D3D3D),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Flexible(
            child: Padding(
              padding: padding ?? const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 24,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    bool showHandle = true,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
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
