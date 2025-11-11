import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  //Colors
  static const Color primaryAccent = Color(0xFF9196FF);
  static const Color secondaryAccent = Color(0xFF5961FF);
  static const Color positive = Color(0XFF63FF60);
  static const Color negative = Color(0xFFC22743);

  //text Colors
  static const Color text1 = Color(0xFFFFFFFF);
  static Color text2 = Color(0xFFFFFFFF).withOpacity(0.72);
  static Color text3 = Color(0xFFFFFFFF).withOpacity(0.48);
  static Color text4 = Color(0xFFFFFFFF).withOpacity(0.32);
  static Color text5 = Color(0xFFFFFFFF).withOpacity(0.16);

  //Base Colors
  static const Color base1 = Color(0xFF101010);
  static const Color base2 = Color(0xFF151515);

  //Surface Colors
  static Color surfaceWhite1 = Color(0xFFFFFFFF).withOpacity(0.02);
  static Color surfaceWhite2 = Color(0xFFFFFFFF).withOpacity(0.05);
  static Color surfaceBlack1 = Color(0xFF101010).withOpacity(0.9);
  static Color surfaceBlack2 = Color(0xFF101010).withOpacity(0.7);
  static Color surfaceBlack3 = Color(0xFF101010).withOpacity(0.5);

  //Border Colors
  static Color border1 = Color(0xFFFFFFFF).withOpacity(0.08);
  static Color border2 = Color(0xFFFFFFFF).withOpacity(0.16);
  static Color border3 = Color(0xFFFFFFFF).withOpacity(0.24);
  static LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      border3,
      surfaceBlack3, 
    ],
  );
}
