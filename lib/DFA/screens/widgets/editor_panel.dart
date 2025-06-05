import 'package:flutter/material.dart';
import 'package:automaton_simulator/DFA/simulator/word_display_widget.dart';
import 'package:automaton_simulator/DFA/simulator/simulation_control_panel.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'package:automaton_simulator/DFA/pages/widgets/animated_border.dart';
import 'package:automaton_simulator/DFA/pages/widgets/editor_widget.dart';

class EditorPanel extends StatelessWidget {
  final Simulator simulator;
  final GlobalKey editorKey;
  final GlobalKey controlPanelKey;

  const EditorPanel({
    super.key,
    required this.simulator,
    required this.editorKey,
    required this.controlPanelKey,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: ValueListenableBuilder(
                      valueListenable: simulator,
                      builder: (context, isSimulating, child) {
                        return Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.deepPurple.shade500,
                                  width: 4.0,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 15.0,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.0),
                                child: DFAEditorWidget(key: editorKey),
                              ),
                            ),
                            AnimatedBorder(isSimulating: isSimulating),
                          ],
                        );
                      },
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: simulator,
                    builder: (context, isSimulating, child) {
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        left: 0,
                        right: 0,
                        height: isSimulating ? 125 : 0,
                        child: WordDisplayWidget(
                          isVisible: isSimulating,
                          simulator: simulator,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              key: controlPanelKey,
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.deepPurple.shade500,
                  width: 4.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: SimulationControlPanel(simulator: simulator),
            ),
          ],
        ),
      ),
    );
  }
}
