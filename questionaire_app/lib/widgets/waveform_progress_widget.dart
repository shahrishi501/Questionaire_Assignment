import 'package:flutter/material.dart';
import 'dart:math';

class WaveProgressIndicator extends StatelessWidget {
  final double progress; // between 0.0 and 1.0
  final Color activeColor;
  final Color inactiveColor;
  final double amplitude; // height of wave
  final double wavelength; // width of one wave cycle
  final double thickness;

  const WaveProgressIndicator({
    super.key,
    required this.progress,
    this.activeColor = const Color(0xFF6C63FF),
    this.inactiveColor = Colors.grey,
    this.amplitude = 2,
    this.wavelength = 20,
    this.thickness = 3,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 50),
      painter: _WavePainter(
        progress: progress,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        amplitude: amplitude,
        wavelength: wavelength,
        thickness: thickness,
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final double amplitude;
  final double wavelength;
  final double thickness;

  _WavePainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.amplitude,
    required this.wavelength,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintActive = Paint()
      ..color = activeColor
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintInactive = Paint()
      ..color = inactiveColor.withOpacity(0.2)
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pathActive = Path();
    final pathInactive = Path();

    double startY = size.height / 2;
    bool inactivePathStarted = false;

    for (double x = 0; x < size.width; x++) {
      double y = startY + sin(x / wavelength * 2 * pi) * amplitude;
      if (x / size.width <= progress) {
        if (x == 0) {
          pathActive.moveTo(x, y);
        } else {
          pathActive.lineTo(x, y);
        }
      } else {
        if (!inactivePathStarted) {
          pathInactive.moveTo(x, y);
          inactivePathStarted = true;
        } else {
          pathInactive.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(pathInactive, paintInactive);
    canvas.drawPath(pathActive, paintActive);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
