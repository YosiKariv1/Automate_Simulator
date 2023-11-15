import 'package:flutter/material.dart';

class NodePaint extends CustomPainter {
  final List<Offset?> circleOffsets;

  NodePaint(this.circleOffsets);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 0.5;

    for (final circleOffset in circleOffsets) {
      if (circleOffset != null) {
        canvas.drawCircle(circleOffset, 30, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// run in loop for each circle in the circleoffsets list (need to check if its work everytime or just if add a circle)
// circleoffsets will be the list in the automate class that contains all the circles

