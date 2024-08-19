import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/classes/automaton_class.dart';
import 'package:myapp/classes/transmition_class.dart';
import 'package:myapp/DFA/pages/widgets/transition_symbol_popup.dart';
import 'package:myapp/DFA/pages/widgets/transition_painter.dart';
import 'package:provider/provider.dart';

class TransitionWidget extends StatelessWidget {
  const TransitionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Automaton>(
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
      Transition transition, String alphabet, Automaton automaton) async {
    Set<String> usedSymbols = automaton.transitions
        .where((t) => t.from == transition.from && t != transition)
        .expand((t) => t.symbol)
        .toSet();

    final result = await showDialog<Set<String>>(
      context: context,
      builder: (BuildContext context) {
        return TransitionSymbolPopup(
          alphabet: alphabet,
          initialSymbols: transition.symbol,
          usedSymbols: usedSymbols,
        );
      },
    );

    if (result != null) {
      transition.updateSymbols(result);
    }
  }

  Widget buildTransitionContainer(Transition transition) {
    Color transitionColor;
    if (transition.isInSimulation) {
      transitionColor = Colors.red;
    } else if (transition.isPermanentHighlighted) {
      transitionColor = Colors.green;
    } else {
      transitionColor = Colors.white;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: const BoxConstraints(
        minWidth: 40,
        maxWidth: 120,
      ),
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
      child: Center(
        child: buildTransitionText(transition.symbol.join(','),
            transition.isInSimulation || transition.isPermanentHighlighted),
      ),
    );
  }

  Widget buildTransitionText(String label, bool isHighlighted) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        color: isHighlighted ? Colors.white : Colors.black,
        fontSize: 12,
        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
