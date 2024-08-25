import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/DFA/pages/widgets/transition_painter.dart';
import 'package:myapp/PDA/tansition_popup.dart';
import 'package:myapp/classes/operations_class.dart';
import 'package:myapp/classes/pda_class.dart';
import 'package:myapp/classes/transition_class.dart';
import 'package:provider/provider.dart';

class PDATransitionWidget extends StatelessWidget {
  const PDATransitionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PDA>(
      builder: (context, automaton, child) {
        return Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: TransitionPainter(
                transitions: automaton.transitions,
                tempTransition: automaton.tempTransition,
                currentMousePosition: automaton.currentMousePosition,
              ),
            ),
            ...automaton.transitions.map((transition) {
              return ChangeNotifierProvider.value(
                value: transition,
                child: Consumer<Transition>(
                  builder: (context, transition, child) {
                    return Positioned.fromRect(
                      rect: transition.textRRect.outerRect,
                      child: GestureDetector(
                        onTap: () => _showEditTransitionDialog(
                            context, transition, automaton.alphabet, automaton),
                        child: AnimatedBuilder(
                          animation: transition,
                          builder: (context, child) {
                            return buildTransitionContainer(
                              transition,
                            );
                          },
                        ),
                      ),
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

  Future<void> _showEditTransitionDialog(BuildContext context,
      Transition transition, String alphabet, PDA automaton) async {
    final result = await showDialog<List<Operations>>(
      context: context,
      builder: (BuildContext context) {
        return PDATransitionPopup(initialOperations: transition.operations);
      },
    );

    if (result != null) {
      transition.setOperations(result);
      transition.notifyListeners();
    }
  }

  Widget buildTransitionContainer(Transition transition) {
    Color transitionColor = transition.isInSimulation
        ? Colors.red
        : (transition.isPermanentHighlighted ? Colors.green : Colors.white);

    // Calculate the dynamic dimensions based on the number of operations
    double dynamicHeight = transition.textRRect.height;
    double dynamicWidth = transition.textRRect.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: dynamicWidth,
      height: dynamicHeight,
      decoration: BoxDecoration(
        color: transitionColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: transition.isInSimulation
              ? Colors.red
              : (transition.isPermanentHighlighted
                  ? Colors.green
                  : Colors.deepPurple),
          width: 2,
        ),
        boxShadow:
            (transition.isInSimulation || transition.isPermanentHighlighted)
                ? [
                    BoxShadow(
                        color: transitionColor.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5)
                  ]
                : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: transition.operations.asMap().entries.map((entry) {
          int index = entry.key;
          Operations operation = entry.value;
          return Column(
            children: [
              if (index > 0)
                const Divider(
                  color: Colors.deepPurple,
                  height: 1,
                  thickness: 1,
                ),
              buildTransitionText(
                operation,
                transition.isInSimulation || transition.isPermanentHighlighted,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildTransitionText(Operations operation, bool isHighlighted) {
    Color backgroundColor;

    if (operation.isCorrect) {
      backgroundColor = Colors.green.withOpacity(0.3);
    } else if (operation.isChecking) {
      backgroundColor = Colors.orange.withOpacity(0.3);
    } else {
      backgroundColor = Colors.transparent;
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Text(
        "${operation.getInputTopSymbol()}, ${operation.getStackPeakSymbol()} -> ${operation.getStackPushSymbol()}, ${operation.getStackPopSymbol()}",
        style: GoogleFonts.roboto(
          color: isHighlighted ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
