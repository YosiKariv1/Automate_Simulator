import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:automaton_simulator/DFA/simulator/word_display_widget.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/DFA/info/dfa_info.dart';
import 'package:automaton_simulator/DFA/info/welcome_popup.dart';
import 'package:automaton_simulator/DFA/pages/widgets/animated_border.dart';
import 'package:automaton_simulator/DFA/pages/widgets/editor_widget.dart';
import 'package:automaton_simulator/DFA/pages/widgets/enter_word_widget.dart';
import 'package:automaton_simulator/DFA/simulator/simulation_control_panel.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DfaPage extends StatefulWidget {
  const DfaPage({super.key});

  @override
  DfaPageState createState() => DfaPageState();
}

class DfaPageState extends State<DfaPage> {
  late Simulator simulator;
  late DFA automaton;

  final GlobalKey editorKey = GlobalKey();
  final GlobalKey regxKey = GlobalKey();
  final GlobalKey controlPanelKey = GlobalKey();
  final GlobalKey infoPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    automaton = Provider.of<DFA>(context, listen: false);
    simulator = Simulator(automaton);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showWelcomeDialog(context);
      showTutorial();
    });
  }

  Widget buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              automaton.reset();
              Navigator.of(context).pop();
            },
          ),
          Text(
            'DFA Simulator',
            style: GoogleFonts.rajdhani(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              showTutorial();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              buildCustomHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWideScreen = constraints.maxWidth > 800;
                    return Flex(
                      direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                      children: [
                        buildEditorPanel(),
                        buildRightPanel(isWideScreen),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditorPanel() {
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
                              child: DFAEditorWidget(key: editorKey),
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
                        top: isSimulating ? 0 : -50,
                        left: 0,
                        right: 0,
                        height: 50,
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

  Widget buildRightPanel(bool isWideScreen) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          buildSmallContainer(),
          buildInfoPanel(),
        ],
      ),
    );
  }

  Widget buildSmallContainer() {
    return Container(
      key: regxKey,
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: Colors.deepPurple,
          width: 4.0,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10.0),
        ],
      ),
      child: const EnterWordWidget(),
    );
  }

  Widget buildInfoPanel() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          key: infoPanelKey,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.0),
            border: Border.all(
              color: Colors.deepPurple.shade500,
              width: 4.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15.0,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'DFA Information',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(12.0),
                  child: DfaInfoWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.deepPurple[900]!.withOpacity(0.8),
      textSkip: "Skip Tutorial",
      textStyleSkip: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.bottomRight,
      skipWidget: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade700,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text("Skip", style: TextStyle(color: Colors.white)),
      ),
    ).show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      _buildTutorialStep(
        "Editor Section",
        editorKey,
        "DFA Editor",
        "This is where you can create and edit your DFA (Deterministic Finite Automaton). "
            "Add states and transitions to define your automaton's behavior.",
        CustomTargetContentPosition(left: 0, bottom: 0),
        width: 100,
        height: 100,
      ),
      _buildTutorialStep(
        "Word Section",
        regxKey,
        "WordInput",
        "Enter a Word here to test against your DFA. "
            "The simulator will check if the DFA accepts the given Word.",
        CustomTargetContentPosition(left: 0, top: 350),
        width: 0,
        height: 100,
      ),
      _buildTutorialStep(
        "Info Section",
        infoPanelKey,
        "DFA Information",
        "This panel provides detailed information about DFAs and their properties. "
            "It's a great resource for learning more about automata theory.",
        CustomTargetContentPosition(left: 0, top: 150),
        width: 0,
        height: 100,
      ),
      _buildTutorialStep(
        "ControlPanel",
        controlPanelKey,
        "Simulation Control Panel",
        "Use these controls to run, pause, and reset the simulation. "
            "You can also step through the simulation one state at a time.",
        CustomTargetContentPosition(bottom: 150),
        width: 300,
        height: 120,
      ),
    ];
  }

  TargetFocus _buildTutorialStep(
    String identify,
    GlobalKey key,
    String title,
    String description,
    CustomTargetContentPosition position, {
    required double width,
    required double height,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: key,
      alignSkip: Alignment.topRight,
      contents: [
        TargetContent(
          align: ContentAlign.custom,
          customPosition: position,
          builder: (context, controller) {
            return LayoutBuilder(
              builder: (context, constraints) {
                double finalWidth =
                    width > 0 ? width : constraints.minWidth * 0.8;
                double finalHeight =
                    height > 0 ? height : constraints.maxHeight * 0.4;

                return Container(
                  width: finalWidth,
                  height: finalHeight,
                  constraints: BoxConstraints(
                    minWidth: 10,
                    maxWidth: constraints.maxWidth * 0.8,
                    minHeight: 50,
                    maxHeight: constraints.maxHeight * 0.8,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.deepPurple[800],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            description,
                            style: TextStyle(
                                color: Colors.deepPurple[700], fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
      shape: ShapeLightFocus.RRect,
      radius: 10,
    );
  }
}
