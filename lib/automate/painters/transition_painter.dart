import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:flutter/material.dart';

class Transition {
  Offset start;
  Offset end;
  NodeModel? node;
  NodeModel? target;

  Transition(this.start, this.end, {this.node, this.target});
}

class TransitionPainter extends CustomPainter {
  List<Transition> transitions;
  Transition? tempTransition;

  TransitionPainter({required this.transitions, this.tempTransition});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;

    //tempetory line for visualizing where to draw the Line
    if (tempTransition != null) {
      canvas.drawLine(tempTransition!.start, tempTransition!.end, paint);
    }

    //the final line between the two nodes
    if (transitions.isNotEmpty) {
      for (var transition in transitions) {
        canvas.drawLine(
            transition.node!.rightCirclePosition() + const Offset(10, 10),
            transition.target!.leftCirclePosition() + const Offset(10, 10),
            paint);

        // the text painter on the line
        const textStyle = TextStyle(
          color: Colors.black,
          fontSize: 20,
        );
        final textSpan = TextSpan(
          text: transition.node!.name,
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final textCenter = ((transition.target!.leftCirclePosition() +
                    const Offset(-30, -40)) +
                (transition.node!.rightCirclePosition() +
                    const Offset(10, 10))) /
            2;

        textPainter.paint(canvas, textCenter);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TransitionPainter oldDelegate) {
    return true;
  }
}
