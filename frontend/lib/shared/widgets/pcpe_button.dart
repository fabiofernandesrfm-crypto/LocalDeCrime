import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PCPEButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;
  final bool fullWidth;
  final bool loading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final bool small;

  const PCPEButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.outlined = false,
    this.fullWidth = false,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 48,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: outlined ? PCPEColors.primary : PCPEColors.pureWhite,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: small ? 16 : 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    if (outlined) {
      return SizedBox(
        width: fullWidth ? double.infinity : width,
        height: small ? 38 : height,
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.transparent,
            foregroundColor: foregroundColor ?? PCPEColors.primary,
            side: BorderSide(color: PCPEColors.primary.withValues(alpha: 0.5), width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: small ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8) : null,
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: small ? 38 : height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? PCPEColors.primary,
          foregroundColor: foregroundColor ?? PCPEColors.pureWhite,
          elevation: 1,
          shadowColor: PCPEColors.primary.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: child,
      ),
    );
  }
}