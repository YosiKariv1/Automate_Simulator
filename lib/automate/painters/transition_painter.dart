import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:flutter/material.dart';

class Transition {
  Offset start;
  Offset end;
  NodeModel? node;
  NodeModel? target;
  Rect? textRect;
  String alphabet;

  Transition(this.start, this.end,
      {this.node, this.target, this.textRect, this.alphabet = ''});
}

class TransitionPainter extends CustomPainter {
  List<Transition> transitions;
  Transition? tempTransition;

  TransitionPainter({required this.transitions, this.tempTransition});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    //tempetory line for visualizing where to draw the Line
    if (tempTransition != null) {
      canvas.drawLine(tempTransition!.start, tempTransition!.end, paint);
    }

    //the final line between the two nodes
    if (transitions.isNotEmpty) {
      for (var transition in transitions) {
        if (transition.node!.name != transition.target!.name) {
          canvas.drawLine(
              transition.node!.rightCirclePosition() + const Offset(10, 10),
              transition.target!.leftCirclePosition() + const Offset(10, 10),
              paint);
        } else {
          var startPosition = transition.node!.rightCirclePosition();
          var controlPoint =
              Offset(startPosition.dx - 25, startPosition.dy - 150);

          var path = Path();
          path.moveTo(transition.node!.rightCirclePosition().dx + 10,
              transition.node!.rightCirclePosition().dy);
          path.quadraticBezierTo(
              controlPoint.dx,
              controlPoint.dy,
              transition.target!.leftCirclePosition().dx + 5,
              transition.target!.leftCirclePosition().dy + 10);

          canvas.drawPath(path, paint);
        }

        // the text painter on the line
        const textStyle = TextStyle(color: Colors.black, fontSize: 20);
        final textSpan = TextSpan(text: transition.alphabet, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final Offset textCenter;

        //where to draw the text in the curve line or straight line
        if (transition.node!.name != transition.target!.name) {
          textCenter = ((transition.target!.leftCirclePosition() +
                      const Offset(-30, -40)) +
                  (transition.node!.rightCirclePosition() +
                      const Offset(10, 10))) /
              2;
        } else {
          textCenter = ((transition.target!.leftCirclePosition() +
                      const Offset(-25, -210)) +
                  (transition.node!.rightCirclePosition() +
                      const Offset(10, 10))) /
              2;
        }

        transition.textRect = Rect.fromCenter(
          center: textCenter,
          width: 50,
          height: 100,
        );

        textPainter.paint(canvas, textCenter);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TransitionPainter oldDelegate) {
    return true;
  }
}
