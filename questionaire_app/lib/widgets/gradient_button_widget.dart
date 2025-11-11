import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:questionaire_app/constants/app_colors.dart';

class GradientButtonWidget extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onPressed;
  const GradientButtonWidget({
    super.key,
    required this.isActive,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onPressed : null,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? GradientBoxBorder(gradient: AppColors.borderGradient, width: 1)
              : Border.all(color: AppColors.border1, width: 1),
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
              : RadialGradient(
                  center: Alignment.topLeft,
                  radius: 7,
                  colors: [
                    Color(0xFF222222).withOpacity(0.2),
                    Color(0xFF999999).withOpacity(0.1),
                    Color(0xFF222222).withOpacity(0.2),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Next",
                style: TextStyle(
                  color: isActive ? AppColors.text1 : AppColors.text4,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "spaceGrotesk"
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/arrow.png',
                color: isActive ? AppColors.text1 : AppColors.text4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
