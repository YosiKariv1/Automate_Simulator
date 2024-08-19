import 'package:flutter/material.dart';
import 'package:arrow_path/arrow_path.dart';
import 'package:myapp/classes/transmition_class.dart';

class TransitionPainter extends CustomPainter {
  final List<Transition> transitions;
  final Transition? tempTransition;
  final Offset? currentMousePosition;
  final bool isForTuringMachine;
  Offset? fromPosition;
  Offset? toPosition;
  Canvas? canvas;

  static const double loopHeight = 150.0;
  static const double loopWidth = 25.0;
  static const double tipLength = 15.0;

  TransitionPainter({
    required this.transitions,
    this.tempTransition,
    this.currentMousePosition,
    this.isForTuringMachine = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    for (var transition in transitions) {
      drawTransition(transition);
    }

    if (!isForTuringMachine &&
        tempTransition != null &&
        currentMousePosition != null) {
      drawTempTransition();
    }
  }

  Paint getPaint({Color? color}) {
    color ??= Colors.deepPurple[800];
    return Paint()
      ..color = color!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  //============================Draw Temporary Line===========================\\
  void drawTempTransition() {
    fromPosition = tempTransition!.from.rightSideNodeCenter;
    if (fromPosition == null) return;

    final path = createPath(fromPosition!, currentMousePosition!);
    drawPath(path, getPaint(color: Colors.deepPurple[300]));
  }

  //=======================Draw Transitions(loopback or direct)==============\\
  void drawTransition(Transition transition) {
    fromPosition = transition.from.rightSideNodeCenter;
    toPosition = transition.to.leftSideNodeCenter;
    Path path;

    if (transition.from == transition.to) {
      path = createLoopbackPath(fromPosition!, toPosition!);
    } else {
      path =
          createPath(fromPosition!, toPosition!, transition.to.smallCircleSize);
    }

    drawPath(path, getPaint());
  }

  //============================Draw LoopBack Line============================\\
  Path createLoopbackPath(Offset start, Offset end) {
    var path = Path();
    path.moveTo(start.dx, start.dy);

    double loopHeight = 150.0;
    double loopWidth = 25.0;
    Offset controlPoint1 = Offset(start.dx - loopWidth, start.dy - loopHeight);
    path.quadraticBezierTo(controlPoint1.dx, controlPoint1.dy, end.dx, end.dy);

    return ArrowPath.addTip(path, tipLength: tipLength);
  }

  //=============Creating And Drawing The Path For The Transition=============\\
  Path createPath(Offset from, Offset to, [double midSmallCircleSize = 0]) {
    var path = Path();
    path.moveTo(from.dx, from.dy);
    if (from.dx > to.dx && from.dy < to.dy) {
      double controlPointX = (from.dx + to.dx) / 2;
      double controlPointY = (from.dy + to.dy) / 2 - 200;
      path.quadraticBezierTo(
          controlPointX, controlPointY, to.dx - midSmallCircleSize / 2, to.dy);
    }
    // Curved path if 'to' is to the left and above 'from'
    else if (from.dx > to.dx && from.dy > to.dy) {
      double controlPointX = (from.dx + to.dx) / 2;
      double controlPointY = (from.dy + to.dy) / 2 + 200;
      path.quadraticBezierTo(
          controlPointX, controlPointY, to.dx - midSmallCircleSize / 2, to.dy);
    }
    // Straight line in other cases
    else {
      path.lineTo(to.dx - midSmallCircleSize / 2, to.dy);
    }

    return ArrowPath.addTip(path);
  }

  void drawPath(Path path, Paint paint) {
    canvas!.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
