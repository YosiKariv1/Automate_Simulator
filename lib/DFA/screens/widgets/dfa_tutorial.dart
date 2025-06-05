import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void showDfaTutorial({
  required BuildContext context,
  required GlobalKey editorKey,
  required GlobalKey regxKey,
  required GlobalKey infoPanelKey,
  required GlobalKey controlPanelKey,
}) {
  TutorialCoachMark(
    targets: _createTargets(
      editorKey: editorKey,
      regxKey: regxKey,
      infoPanelKey: infoPanelKey,
      controlPanelKey: controlPanelKey,
    ),
    colorShadow: Colors.deepPurple[900]!,
    hideSkip: false,
    skipWidget: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade700,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.deepPurple.shade900,
          width: 2,
        ),
      ),
      child: const Text(
        'Skip',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ).show(context: context);
}

List<TargetFocus> _createTargets({
  required GlobalKey editorKey,
  required GlobalKey regxKey,
  required GlobalKey infoPanelKey,
  required GlobalKey controlPanelKey,
}) {
  return [
    _buildTutorialStep(
      id: 'Editor Section',
      key: editorKey,
      title: 'Visual DFA Builder',
      description:
          'Use this interactive editor to visually design your DFA. Tap to add states, drag to reposition them, and draw transitions to define how your automaton behaves. This is the heart of your simulation.',
      position: const CustomTargetContentPosition(top: 100, left: 10),
      alignment: Alignment.centerLeft,
      maxWidth: 350,
      minHeight: 185,
    ),
    _buildTutorialStep(
      id: 'Word Section',
      key: regxKey,
      title: 'Word Input',
      description:
          'Enter a Word here to test against your DFA. The simulator will check if the DFA accepts the given Word.',
      position: const CustomTargetContentPosition(top: 80, right: 500),
      alignment: Alignment.topRight,
    ),
    _buildTutorialStep(
      id: 'Info Section',
      key: infoPanelKey,
      title: 'DFA Information / Table',
      description:
          "This panel provides detailed information about DFAs and their properties. It's a great resource for learning more about automata theory.",
      position: const CustomTargetContentPosition(top: 300, right: 500),
      alignment: Alignment.centerRight,
    ),
    _buildTutorialStep(
      id: 'Control Panel',
      key: controlPanelKey,
      title: 'Simulation Control Panel',
      description:
          'Use these controls to run, pause, and reset the simulation. You can also step through the simulation one state at a time.',
      position: const CustomTargetContentPosition(bottom: 150),
      alignment: Alignment.centerLeft,
    ),
  ];
}

TargetFocus _buildTutorialStep({
  required String id,
  required GlobalKey key,
  required String title,
  required String description,
  CustomTargetContentPosition? position,
  Alignment alignment = Alignment.center,
  double maxWidth = 300,
  double minHeight = 150,
}) {
  return TargetFocus(
    identify: id,
    keyTarget: key,
    alignSkip: Alignment.topRight,
    contents: [
      TargetContent(
        align: ContentAlign.custom,
        customPosition: position,
        builder: (context, controller) {
          return Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minHeight: minHeight,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ],
    shape: ShapeLightFocus.RRect,
    radius: 10,
  );
}
