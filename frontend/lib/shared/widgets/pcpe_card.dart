import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PCPECard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool showBorder;

  const PCPECard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevation = 2,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? PCPEColors.pureWhite,
        borderRadius: borderRadius ?? BorderRadius.circular(14),
        border: showBorder
            ? Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3), width: 0.5)
            : null,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: elevation * 2.5,
                offset: Offset(0, elevation),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(14),
        splashColor: PCPEColors.primary.withValues(alpha: 0.05),
        highlightColor: PCPEColors.primary.withValues(alpha: 0.03),
        child: card,
      );
    }

    return card;
  }
}