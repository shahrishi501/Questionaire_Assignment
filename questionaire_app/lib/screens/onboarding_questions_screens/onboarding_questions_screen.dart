import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

// Local Imports
import 'package:questionaire_app/constants/app_colors.dart';
import 'package:questionaire_app/widgets/audio_recording_widget.dart';
import 'package:questionaire_app/widgets/gradient_button_widget.dart';
import 'package:questionaire_app/widgets/gradient_icon_widget.dart';
import 'package:questionaire_app/widgets/textfield_widget.dart';
import 'package:questionaire_app/widgets/video_recording_widget.dart';
import 'package:questionaire_app/widgets/waveform_progress_widget.dart';

class OnboardingQuestionsScreen extends StatefulWidget {
  const OnboardingQuestionsScreen({super.key});

  @override
  State<OnboardingQuestionsScreen> createState() => _OnboardingQuestionsScreenState();
}

class _OnboardingQuestionsScreenState extends State<OnboardingQuestionsScreen> {
  final TextEditingController textController = TextEditingController();
  bool isRecording = false;
  bool isMicActive = false;
  bool isVideoActive = false;
  bool isVideoRecording = false;
  bool hasAudioRecorded = false;
  bool hasVideoRecorded = false;
  
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  int selectedCameraIndex = 0;
  String? videoPath;
  VideoPlayerController? _videoPlayerController;
  Duration videoDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
     try {
      cameras = await availableCameras();
    } catch (e) {
      print('Error initializing cameras: $e');
      cameras = [];
    }
  }

  Future<void> _switchCamera() async {
  if (cameras == null || cameras!.isEmpty) return;

  selectedCameraIndex = (selectedCameraIndex + 1) % cameras!.length;

  await _cameraController?.dispose();
  _cameraController = CameraController(
    cameras![selectedCameraIndex],
    ResolutionPreset.medium,
    enableAudio: true,
  );
  await _cameraController!.initialize();
  setState(() {});
}

  Future<void> _toggleMic() async {
    final status = await Permission.microphone.request();
    
    if (status == PermissionStatus.granted) {
      setState(() {
       if (!isMicActive) {
          isMicActive = true;
          isRecording = true;

          isVideoActive = false;
          isVideoRecording = false;
        } else {
          // Stop recording
          isRecording = false;
          isMicActive = false;
        }
      });
    }
  }

  Future<void> _toggleVideo() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();
    
    if (cameraStatus == PermissionStatus.granted && micStatus == PermissionStatus.granted) {
      if (!isVideoActive) {
        // Start video mode
        await _startCamera();
        setState(() {
          isVideoActive = true;
          isMicActive = false;
          isRecording = false;
        });
      } else {
        // Toggle recording
        if (isVideoRecording) {
          await _stopVideoRecording();
        } else {
          await _startVideoRecording();
        }
      }
    }
  }

  Future<void> _startCamera() async {
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras!.first,
        ResolutionPreset.medium,
        enableAudio: true,
      );
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        await _cameraController!.startVideoRecording();
        setState(() {
          isVideoRecording = true;
        });
      } catch (e) {
        print('Error starting video recording: $e');
      }
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController != null && _cameraController!.value.isRecordingVideo) {
      try {
        final XFile video = await _cameraController!.stopVideoRecording();
        videoPath = video.path;
        
        // Initialize video player to get duration and thumbnail
        _videoPlayerController = VideoPlayerController.file(File(video.path));
        await _videoPlayerController!.initialize();
        
        setState(() {
          isVideoRecording = false;
          hasVideoRecorded = true;
          isVideoActive = false;
          videoDuration = _videoPlayerController!.value.duration;
        });
        
        // Dispose camera controller after recording
        await _cameraController!.dispose();
        _cameraController = null;
        
      } catch (e) {
        print('Error stopping video recording: $e');
      }
    }
  }

  void onAudioRecordingComplete() {
    setState(() {
      hasAudioRecorded = true;
      isRecording = false;
      isMicActive = false;
    });
  }

  void deleteRecording() {
    setState(() {
      isRecording = false;
      isMicActive = false;
      hasAudioRecorded = false;
    });
  }

  void _deleteVideo() {
    setState(() {
      hasVideoRecorded = false;
      videoPath = null;
      videoDuration = Duration.zero;
    });
    
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
    
    // Delete the video file
    if (videoPath != null) {
      File(videoPath!).delete();
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base1,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite1,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: SizedBox(
            width: 300,
            child: Center(
              child: WaveProgressIndicator(
                progress: 0.75,
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
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                              MediaQuery.of(context).padding.top - 
                              kToolbarHeight - 
                              MediaQuery.of(context).viewInsets.bottom - 20,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '01',
                          style: TextStyle(
                            color: AppColors.text5,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            fontFamily: "spaceGrotesk",
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Why do you want to host with us?',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.text1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "spaceGrotesk",
                            letterSpacing: -0.48,
                            height: 1.33,
                          ),
                        ),
                        Text('Tell us about your intent and what motivates you to create experiences.', 
                          style: TextStyle(
                            color: AppColors.text3,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "spaceGrotesk",
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Camera Preview
                    if (isVideoActive && _cameraController != null && _cameraController!.value.isInitialized)
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            height: 500,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _switchCamera,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.cameraswitch, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    
                    TextfieldWidget(hintText: '/ Start typing here', textController: textController, maxLength: 600, maxLines: 8,),
                    
                    SizedBox(height: 16,),
                    
                    if(isRecording || hasAudioRecorded)
                      AudioRecordingWidget(onDelete: deleteRecording, onComplete: onAudioRecordingComplete,),
                    
                    if(hasVideoRecorded && _videoPlayerController != null)
                      VideoRecordingWidget(
                        videoPlayerController: _videoPlayerController!,
                        duration: videoDuration,
                        onDelete: _deleteVideo,
                      ),
              
                    SizedBox(height: 16),
              
                    Row(
                      children: [
                        // Animate disappearance of mic + video buttons
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: 56,
                          width: (hasVideoRecorded || hasAudioRecorded) ? 0 : 100,
                          child: (hasVideoRecorded || hasAudioRecorded)
                            ? const SizedBox.shrink()
                            : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _toggleMic,
                                    child: GradientIconWidget(
                                      icon: Icons.mic_none,
                                      isActive: isMicActive,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: AppColors.border1,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _toggleVideo,
                                    child: GradientIconWidget(
                                      icon: isVideoRecording
                                          ? Icons.stop
                                          : Icons.videocam_outlined,
                                      isActive: isVideoActive || isVideoRecording,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: (hasVideoRecorded || hasAudioRecorded) ? 0 : 16,
                          child: const SizedBox(),
                        ),
                    
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: double.infinity,
                            child: GestureDetector(
                              child: GradientButtonWidget(
                                isActive: hasVideoRecorded || isRecording || hasAudioRecorded, 
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}