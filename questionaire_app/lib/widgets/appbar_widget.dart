import 'package:flutter/material.dart';

// Local Imports
import 'package:questionaire_app/constants/app_colors.dart';
import 'package:questionaire_app/widgets/waveform_progress_widget.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final double progress;
  const AppbarWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: AppColors.surfaceWhite1,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: SizedBox(
            width: 300,
            child: Center(
              child: WaveProgressIndicator(
                progress: progress, 
                activeColor: AppColors.primaryAccent,
                inactiveColor: AppColors.border2,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text1),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.clear, color: AppColors.text1),
          ),
        ],
      );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}