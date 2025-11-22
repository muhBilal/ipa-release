import 'dart:ui';
import 'package:flutter/material.dart';

class GlassMorphismCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? selectedBackground;
  final Color? selectedBorderColor;
  final double blurStrength;

  const GlassMorphismCard({
    Key? key,
    required this.child,
    this.margin,
    this.isSelected = false,
    this.onTap,
    this.backgroundColor,
    this.selectedBackground,
    this.selectedBorderColor,
    this.blurStrength = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackground = isSelected
        ? (selectedBackground ?? const Color(0xFF0288D1).withOpacity(0.08))
        : (backgroundColor ?? Colors.white.withOpacity(0.6));

    final Color effectiveBorder = isSelected
        ? (selectedBorderColor ?? const Color(0xFF0288D1).withOpacity(0.4))
        : Colors.white.withOpacity(0.25);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: effectiveBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurStrength,
            sigmaY: blurStrength,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: effectiveBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onTap,
                splashColor: const Color(0xFF4FC3F7).withOpacity(0.15),
                highlightColor: const Color(0xFF4FC3F7).withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
