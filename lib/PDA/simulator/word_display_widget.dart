import 'package:flutter/material.dart';
import 'package:automaton_simulator/PDA/simulator/pda_simulator.dart';

class PDAWordDisplayWidget extends StatelessWidget {
  final bool isVisible;
  final PDASimulator simulator;

  const PDAWordDisplayWidget({
    super.key,
    required this.isVisible,
    required this.simulator,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: simulator,
      builder: (context, _) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isVisible && simulator.isSimulationStarted ? 1.0 : 0.0,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 100,
                maxWidth: 500,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: RichText(
                text: TextSpan(
                  children: _buildTextSpans(
                    simulator.pda.word,
                    simulator.pda.pdaStack.stack,
                    simulator.inputIndex,
                    simulator.algorithmFinished,
                    !simulator.algorithmFinished,
                    simulator.pda.pdaStack.stack.isEmpty,
                    simulator.currentSymbol == 'ε',
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  List<TextSpan> _buildTextSpans(
    String input,
    List<String> stack,
    int currentIndex,
    bool isAlgorithmFinished,
    bool isSimulationStarted,
    bool isStackEmpty,
    bool isCurrentSymbolEpsilon,
  ) {
    List<TextSpan> spans = [];
    for (int i = 0; i < input.length; i++) {
      Color color;
      FontWeight weight = FontWeight.normal;

      if (i == currentIndex && !isCurrentSymbolEpsilon) {
        color = Colors.blue;
        weight = FontWeight.bold;
      } else if (i < currentIndex) {
        color = Colors.green;
      } else {
        color = Colors.black;
      }

      spans.add(TextSpan(
        text: input[i],
        style: TextStyle(
          color: color,
          fontWeight: weight,
          fontSize: 20,
        ),
      ));
    }

    if (isAlgorithmFinished) {
      spans.add(TextSpan(
        text: isStackEmpty ? " (Accepted)" : " (Rejected)",
        style: TextStyle(
          color: isStackEmpty ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    return spans;
  }
}
