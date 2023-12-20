import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:flutter/material.dart';

class NodePainter extends CustomPainter {
  Offset position = const Offset(30, 30);
  final double diameter = 60.0;
  NodeModel node;

  NodePainter(this.node);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xff87cb2e)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, diameter / 2, paint);

    // Preparing the text painter'i
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );
    final textSpan = TextSpan(
      text: node.name,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textCenter = Offset(
      position.dx - (textPainter.width / 2),
      position.dy - (textPainter.height / 2),
    );

    textPainter.paint(canvas, textCenter);
  }

  @override
  bool shouldRepaint(NodePainter oldDelegate) {
    return oldDelegate.position != position;
  }
}
