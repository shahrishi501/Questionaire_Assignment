import 'package:flutter/material.dart';

// Local Imports
import 'package:questionaire_app/constants/app_colors.dart';

class TextfieldWidget extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final int? maxLength;
  final int? maxLines;
  const TextfieldWidget({
    super.key,
    required this.hintText,
    required this.textController,
    this.maxLength,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      maxLines: maxLines ?? 6,
      maxLength: maxLength,
      style: TextStyle(
        color: AppColors.text1,
        fontSize: 16,
        fontFamily: "spaceGrotesk",
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.text5,
          fontSize: 20,
          fontFamily: "spaceGrotesk",
        ),
        filled: true,
        fillColor: AppColors.surfaceWhite1,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primaryAccent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
