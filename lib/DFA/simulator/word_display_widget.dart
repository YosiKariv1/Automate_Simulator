import 'package:flutter/material.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'package:provider/provider.dart';

class WordDisplayWidget extends StatelessWidget {
  final bool isVisible;
  final Simulator simulator;

  const WordDisplayWidget({
    super.key,
    required this.isVisible,
    required this.simulator,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DFA>(
      builder: (context, automaton, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isVisible ? 1.0 : 0.0,
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ValueListenableBuilder<bool>(
                valueListenable: simulator,
                builder: (context, _, __) {
                  return RichText(
                    text: TextSpan(
                      children: _buildTextSpans(
                        automaton.word,
                        simulator.processedSymbols,
                        simulator.lastProcessedIndex,
                        simulator.lastStepType,
                        simulator.isSimulating,
                        simulator.algorithmFinished,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<TextSpan> _buildTextSpans(
    String input,
    List<String> processedSymbols,
    int lastProcessedIndex,
    SimulationStepType? lastStepType,
    bool isSimulating,
    bool algorithmFinished,
  ) {
    List<TextSpan> spans = [];
    for (int i = 0; i < input.length; i++) {
      Color color;
      FontWeight weight = FontWeight.normal;

      if (i <= lastProcessedIndex && (isSimulating || algorithmFinished)) {
        color = Colors.green;
      } else if (i == lastProcessedIndex + 1 &&
          lastStepType == SimulationStepType.error) {
        color = Colors.red;
        weight = FontWeight.bold;
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

    if (algorithmFinished) {
      if (lastStepType == SimulationStepType.accept) {
        spans.add(const TextSpan(
          text: " (מתקבל)",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ));
      } else if (lastStepType == SimulationStepType.reject) {
        spans.add(const TextSpan(
          text: " (נדחה)",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ));
      } else if (lastStepType == SimulationStepType.error) {
        spans.add(const TextSpan(
          text: " (שגיאה)",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ));
      }
    }

    return spans;
  }
}
