import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';

// Local Imports
import 'package:questionaire_app/constants/app_colors.dart';

class AudioRecordingWidget extends StatefulWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;
  const AudioRecordingWidget({super.key, this.onDelete, this.onComplete});

  @override
  State<AudioRecordingWidget> createState() => _AudioRecordingWidgetState();
}

class _AudioRecordingWidgetState extends State<AudioRecordingWidget> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  late final RecorderController _recorderController;
  late final PlayerController _playerController;

  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isPlayerReady = false;
  String? _filePath;

  // Timer related variables
  Timer? _timer;
  int _recordingDuration = 0; // in seconds
  int _totalDuration = 0; // total recorded duration

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController();
    _playerController = PlayerController();
    _setupPlayerController();
    _startRecording();
  }

  void _setupPlayerController() {
    _playerController.onPlayerStateChanged.listen((playerState) {
      setState(() {
        _isPlaying = playerState.isPlaying;
      });
    });

    _playerController.onCompletion.listen((_) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  /// Initializes and starts audio recording
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        _filePath =
            '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(RecordConfig(), path: _filePath!);

        // Start waveform animation
        _recorderController.record();

        // Start timer
        _startTimer();

        setState(() => _isRecording = true);
      } else {
        debugPrint("Microphone permission not granted.");
      }
    } catch (e) {
      debugPrint("Error starting recording: $e");
    }
  }

  /// Stops audio recording
  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _recorderController.stop();

      // Stop timer and save total duration
      _stopTimer();
      _totalDuration = _recordingDuration;

      setState(() => _isRecording = false);

      // Prepare waveform for playback after UI update
      if (_filePath != null) {
        await _playerController.preparePlayer(
          path: _filePath!,
          shouldExtractWaveform: true,
        );
        setState(() => _isPlayerReady = true);
      }
      widget.onComplete?.call();
      debugPrint("Recording saved at: $path");
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }
  }

  /// Plays the recorded audio
  Future<void> _playAudio() async {
    try {
      if (_filePath != null && _isPlayerReady) {
        await _playerController.startPlayer();
      }
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  /// Pauses the audio playback
  Future<void> _pauseAudio() async {
    try {
      await _playerController.pausePlayer();
    } catch (e) {
      debugPrint("Error pausing audio: $e");
    }
  }

  /// Stops the audio playback
  Future<void> _stopAudio() async {
    try {
      await _playerController.stopPlayer();
    } catch (e) {
      debugPrint("Error stopping audio: $e");
    }
  }

  /// Deletes recording and resets UI
  Future<void> _deleteRecording() async {
    try {
      if (_isRecording) await _stopRecording();
      if (_isPlaying) await _stopAudio();

      if (_filePath != null && File(_filePath!).existsSync()) {
        await File(_filePath!).delete();
      }

      // Reset timer
      _stopTimer();
      _recordingDuration = 0;
      _totalDuration = 0;

      setState(() {
        _filePath = null;
        _isPlayerReady = false;
      });
      widget.onDelete?.call();
    } catch (e) {
      debugPrint("Error deleting recording: $e");
    }
  }

  /// Starts the recording timer
  void _startTimer() {
    _recordingDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  /// Stops the recording timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Formats duration in MM:SS format
  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _stopTimer();
    _recorderController.dispose();
    _playerController.dispose();
    _audioRecorder.dispose();
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
        child: Column(
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      _isRecording
                          ? 'Recording Audio...'
                          : _isPlaying
                          ? 'Playing Audio...'
                          : _filePath != null
                          ? 'Audio Recorded'
                          : 'Recording Audio...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "spaceGrotesk",
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!_isRecording && !_isPlaying && _filePath != null)
                      Text(
                        '• ${_formatDuration(_totalDuration)}',
                        style: TextStyle(
                          color: AppColors.border2,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "spaceGrotesk",
                        ),
                      ),
                  ],
                ),
                IconButton(
                  onPressed: _deleteRecording,
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.primaryAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Control buttons + Waveform row
            Row(
              children: [
                // Recording/Play button
                GestureDetector(
                  onTap: _isRecording
                      ? _stopRecording
                      : _isPlaying
                      ? _pauseAudio
                      : (_filePath != null ? _playAudio : _startRecording),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording
                          ? AppColors.primaryAccent
                          : AppColors.secondaryAccent,
                    ),
                    child: Icon(
                      _isRecording
                          ? Icons.stop
                          : _isPlaying
                          ? Icons.pause
                          : (_filePath != null
                                ? Icons.play_arrow
                                : Icons.mic_none),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Waveform display
                Expanded(
                  child: _isRecording || (_filePath != null && !_isPlayerReady)
                      ? AudioWaveforms(
                          enableGesture: false,
                          size: Size(
                            MediaQuery.of(context).size.width * 0.6,
                            40,
                          ),
                          recorderController: _recorderController,
                          waveStyle: const WaveStyle(
                            waveColor: Colors.white,
                            showMiddleLine: false,
                            extendWaveform: true,
                            waveThickness: 2.5,
                            spacing: 4.0,
                            scaleFactor: 50,
                          ),
                        )
                      : _isPlayerReady
                      ? AudioFileWaveforms(
                          size: Size(
                            MediaQuery.of(context).size.width * 0.6,
                            40,
                          ),
                          playerController: _playerController,
                          enableSeekGesture: true,
                          waveformType: WaveformType.long,
                          playerWaveStyle: const PlayerWaveStyle(
                            fixedWaveColor: Colors.white54,
                            liveWaveColor: Colors.white,
                            spacing: 6,
                            showSeekLine: false,
                            waveCap: StrokeCap.round,
                          ),
                        )
                      : Container(),
                ),

                const SizedBox(width: 8),

                if (_isRecording)
                  Text(
                    _formatDuration(_recordingDuration),
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "spaceGrotesk",
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
