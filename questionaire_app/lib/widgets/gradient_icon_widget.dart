import 'package:flutter/material.dart';

class GradientIconWidget extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const GradientIconWidget({super.key, required this.icon, required this.isActive, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: isActive
              ? RadialGradient(
                  center: Alignment.topLeft,
                  radius: 7,
                  colors: [
                    Color(0xFF222222).withOpacity(0.2),
                    Color(0xFF999999).withOpacity(0.25),
                    Color(0xFF222222).withOpacity(0.2),
                  ],
                  stops: [0.0, 0.5, 1.0],
                )
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}