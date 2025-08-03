import 'dart:math';

import 'package:flutter/material.dart';

import '../constants.dart';

class Arc extends StatelessWidget {
  const Arc({
    super.key,
    required this.figure,
    this.figureUnit = '%',
    this.color,
  });

  final num figure;
  final String figureUnit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: const Size(100, 60),
            painter: _SemiArcPainter(percentage: figure, fillColor: color,),
          ),
          Positioned(
            child: Text(
                '${figure.toStringAsFixed(0)}$figureUnit',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color ?? primaryBlue
                )
            ),
          ),
        ],
      ),
    );
  }
}

class _SemiArcPainter extends CustomPainter {
  _SemiArcPainter({required this.percentage, this.fillColor});

  final num percentage;
  final Color? fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    final backgroundPaint = Paint()
      ..color = primaryGrey20
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..color = fillColor ?? primaryBlue
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      backgroundPaint,
    );

    double sweepAngle = pi * (percentage / 100);
    canvas.drawArc(
      rect,
      pi,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}