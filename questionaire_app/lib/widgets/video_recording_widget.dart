import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:questionaire_app/constants/app_colors.dart';

class VideoRecordingWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final Duration duration;
  final VoidCallback onDelete;

  const VideoRecordingWidget({
    super.key,
    required this.videoPlayerController,
    required this.duration,
    required this.onDelete,
  });

  @override
  State<VideoRecordingWidget> createState() => _VideoRecordingWidgetState();
}

class _VideoRecordingWidgetState extends State<VideoRecordingWidget> {
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.setLooping(true);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showVideoPreview(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      barrierDismissible: true,
      barrierLabel: 'Close video preview',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio:
                      widget.videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(widget.videoPlayerController),
                ),
              ),
              // Play/Pause overlay
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (widget.videoPlayerController.value.isPlaying) {
                      await widget.videoPlayerController.pause();
                    } else {
                      await widget.videoPlayerController.play();
                    }
                    setState(() {});
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: widget.videoPlayerController.value.isPlaying ? 0 : 1,
                    child: Icon(
                      Icons.play_circle_fill,
                      color: widget.videoPlayerController.value.isPlaying ? Colors.transparent : Colors.white,
                      size: 90,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () async {
                    await widget.videoPlayerController.pause();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.videoPlayerController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 7,
          colors: [
            const Color(0xFF222222).withOpacity(0.2),
            const Color(0xFF999999).withOpacity(0.25),
            const Color(0xFF222222).withOpacity(0.2),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFFFFFF).withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _showVideoPreview(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: widget.videoPlayerController.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(widget.videoPlayerController),
                            AnimatedOpacity(
                              opacity: isPlaying ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 250),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Video Recorded",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "spaceGrotesk",
                      ),
                    ),
                    Text(
                      '• ${_formatDuration(widget.duration)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "spaceGrotesk",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: widget.onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.primaryAccent,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
