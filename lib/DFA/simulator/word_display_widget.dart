import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          duration: const Duration(milliseconds: 350),
          opacity: isVisible ? 1.0 : 0.0,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 80,
                maxWidth: 270,
                minHeight: 60,
                maxHeight: 80,
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Colors.deepPurple.shade300,
                  width: 1.6,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.deepPurple,
                    blurRadius: 9,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ValueListenableBuilder<bool>(
                valueListenable: simulator,
                builder: (context, _, __) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildCharBoxes(
                              automaton.word,
                              simulator.lastProcessedIndex,
                              simulator.lastStepType,
                              simulator.isSimulating,
                              simulator.algorithmFinished,
                            ),
                          ),
                        ),
                        if (simulator.algorithmFinished)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: _buildResult(simulator.lastStepType),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildCharBoxes(
    String word,
    int lastProcessedIndex,
    SimulationStepType? lastStepType,
    bool isSimulating,
    bool algorithmFinished,
  ) {
    if (word.isEmpty) {
      return [
        Text(
          "-",
          style: GoogleFonts.robotoMono(fontSize: 18, color: Colors.grey),
        )
      ];
    }

    return List.generate(word.length, (i) {
      Color borderColor = Colors.deepPurple.shade100;
      Color bgColor = Colors.grey.shade50;
      Color textColor = Colors.deepPurple.shade700;
      FontWeight fontWeight = FontWeight.normal;

      if (i <= lastProcessedIndex && (isSimulating || algorithmFinished)) {
        borderColor = Colors.green.shade400;
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade900;
        fontWeight = FontWeight.bold;
      } else if (i == lastProcessedIndex + 1 &&
          lastStepType == SimulationStepType.error) {
        borderColor = Colors.red.shade400;
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        fontWeight = FontWeight.bold;
      } else if (i == lastProcessedIndex + 1 && isSimulating) {
        borderColor = Colors.deepPurple.shade400;
        bgColor = Colors.deepPurple.shade50;
        textColor = Colors.deepPurple.shade900;
        fontWeight = FontWeight.bold;
      }

      return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          word[i],
          style: GoogleFonts.robotoMono(
            fontSize: 16.5,
            fontWeight: fontWeight,
            color: textColor,
            letterSpacing: 1.1,
          ),
        ),
      );
    });
  }

  Widget _buildResult(SimulationStepType? lastStepType) {
    if (lastStepType == SimulationStepType.accept) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade700, size: 18),
          const SizedBox(width: 5),
          Text(
            "Accepted",
            style: GoogleFonts.poppins(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      );
    } else if (lastStepType == SimulationStepType.reject) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cancel, color: Colors.red.shade700, size: 18),
          const SizedBox(width: 5),
          Text(
            "Rejected",
            style: GoogleFonts.poppins(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      );
    } else if (lastStepType == SimulationStepType.error) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Colors.orange.shade700, size: 16),
          const SizedBox(width: 5),
          Text(
            "Error",
            style: GoogleFonts.poppins(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
