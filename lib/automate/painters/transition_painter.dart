import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/transition_model.dart';
import 'package:arrow_path/arrow_path.dart';

class TransitionPainter extends CustomPainter {
  final List<TransitionModel> transitions;
  final TransitionModel? tempTransition;

  TransitionPainter({required this.transitions, this.tempTransition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var transition in transitions) {
      if (transition.node == transition.target) {
        // Handle loopback transition (node to itself) with a curved path
        var loopbackPath = _createLoopbackPath(transition);
        canvas.drawPath(loopbackPath, paint);
      } else {
        // Handle direct transition with a straight line
        var directPath = _createDirectPath(transition);
        canvas.drawPath(directPath, paint);
      }
    }

    // Draw temporary transition if it exists
    if (tempTransition != null) {
      var tempPath = _createTemporaryPath(tempTransition!);
      canvas.drawPath(tempPath, paint..color = Colors.grey);
    }
  }

  Path _createLoopbackPath(TransitionModel transition) {
    var path = Path();
    var controlPoint1 =
        Offset(transition.start.dx + 50, transition.start.dy - 100);
    var controlPoint2 = Offset(transition.end.dx - 20, transition.end.dy - 100);
    path.moveTo(transition.start.dx + 15, transition.start.dy + 10);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, transition.end.dx + 5, transition.end.dy + 5);
    return ArrowPath.addTip(path);
  }

  Path _createDirectPath(TransitionModel transition) {
    var path = Path();
    path.moveTo(transition.start.dx + 10, transition.start.dy + 10);
    path.lineTo(transition.end.dx - 2, transition.end.dy + 10);
    return ArrowPath.addTip(path);
  }

  Path _createTemporaryPath(TransitionModel transition) {
    var path = Path();
    path.moveTo(transition.start.dx, transition.start.dy);
    path.lineTo(transition.end.dx, transition.end.dy);
    return ArrowPath.addTip(path);
  }

  @override
  bool shouldRepaint(covariant TransitionPainter oldDelegate) {
    return true;
  }
}
