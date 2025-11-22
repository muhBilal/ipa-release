import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x20ADD8E6), 
            Color(0x20B0E0E6), 
            Color(0x20E0FFFF), 
          ],
        ),
      ),
      child: child,
    );
  }
}
