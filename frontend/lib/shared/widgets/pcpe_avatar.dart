import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PCPEAvatar extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final IconData? icon;
  final bool showBadge;
  final Color? badgeColor;

  const PCPEAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = 48,
    this.backgroundColor,
    this.icon,
    this.showBadge = false,
    this.badgeColor,
  });

  String get initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? PCPEColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(size / 3),
            border: Border.all(
              color: PCPEColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(size / 3 - 2),
                  child: Icon(
                    icon ?? Icons.person,
                    size: size * 0.5,
                    color: PCPEColors.primary,
                  ),
                )
              : icon != null
                  ? Icon(icon, size: size * 0.5, color: PCPEColors.primary)
                  : Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: size * 0.35,
                          fontWeight: FontWeight.w700,
                          color: PCPEColors.primary,
                        ),
                      ),
                    ),
        ),
        if (showBadge)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: badgeColor ?? PCPEColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: PCPEColors.pureWhite, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}