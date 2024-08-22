import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/DFA/pages/widgets/transition_painter.dart';
import 'package:myapp/classes/turing_machine_class.dart';
import 'package:myapp/classes/transition_class.dart';
import 'package:provider/provider.dart';

class TuringTransitionWidget extends StatelessWidget {
  const TuringTransitionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TuringMachine>(
      builder: (context, turingMachine, child) {
        return Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: TransitionPainter(
                transitions: turingMachine.transitions,
                isForTuringMachine: true,
              ),
            ),
            ...turingMachine.transitions.map((transition) {
              return ChangeNotifierProvider.value(
                value: transition,
                child: Consumer<Transition>(
                  builder: (context, transition, child) {
                    return Positioned.fromRect(
                      rect: transition.textRRect.outerRect,
                      child: buildTransitionContainer(transition),
                    );
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget buildTransitionContainer(Transition transition) {
    String transitionLabel =
        '${transition.read},${transition.write}/${transition.direction[0]}';

    Color borderColor;
    Color backgroundColor;

    if (transition.isPermanentHighlighted) {
      borderColor = Colors.green;
      backgroundColor = Colors.green[100]!;
    } else if (transition.isPending) {
      borderColor = Colors.deepOrangeAccent;
      backgroundColor = Colors.deepOrangeAccent[100]!;
    } else {
      borderColor = Colors.deepPurple;
      backgroundColor = Colors.white;
    }

    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            boxShadow:
                transition.isInSimulation || transition.isPermanentHighlighted
                    ? [
                        BoxShadow(
                          color: borderColor.withOpacity(0.8),
                          spreadRadius: 4,
                          blurRadius: 8,
                        ),
                      ]
                    : [],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              transitionLabel,
              style: GoogleFonts.poppins(
                color: borderColor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
