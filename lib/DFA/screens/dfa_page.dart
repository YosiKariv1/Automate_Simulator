import 'package:automaton_simulator/DFA/screens/widgets/panel_container.dart';
import 'package:flutter/material.dart';
import 'package:automaton_simulator/DFA/simulator/word_display_widget.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/DFA/info/dfa_table.dart';
import 'package:automaton_simulator/DFA/info/dfa_welcom_popup.dart';
import 'package:automaton_simulator/DFA/screens/widgets/animated_border.dart';
import 'package:automaton_simulator/DFA/screens/widgets/editor_widget.dart';
import 'package:automaton_simulator/DFA/screens/widgets/enter_word_widget.dart';
import 'package:automaton_simulator/DFA/simulator/simulation_control_panel.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            icon: const Icon(FontAwesomeIcons.arrowLeft,
                color: Colors.white, size: 22),
            onPressed: () {
              automaton.reset();
              Navigator.of(context).pop();
            },
          ),
          const Text(
            'DFA Simulator',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.circleQuestion,
                  color: Colors.white, size: 22),
              onPressed: () {
                showTutorial();
              },
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(top: 15),
      child: PanelContainer(
        title: 'Input Word',
        icon: IconButton(
          onPressed: () {
            // show info
          },
          icon: const Icon(Icons.info_outline, color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: const EnterWordWidget(),
      ),
    );
  }

  Widget buildInfoPanel() {
    return Expanded(
      child: PanelContainer(
        title: 'DFA Information',
        icon: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.info_outline, color: Colors.white),
        ),
        containerKey: infoPanelKey,
        scrollable: true,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: const DfaTable(),
      ),
    );
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: _createTargets(),
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
        child: const Text("Skip",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            )),
      ),
    ).show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      _buildTutorialStep(
        id: "Editor Section",
        key: editorKey,
        title: "Visual DFA Builder",
        description: "Use this interactive editor to visually design your DFA. "
            "Tap to add states, drag to reposition them, and draw transitions to define how your automaton behaves. "
            "This is the heart of your simulation.",
        position: CustomTargetContentPosition(top: 100, left: 10),
        alignment: Alignment.centerLeft,
        maxWidth: 350,
        minHeight: 185,
      ),
      _buildTutorialStep(
        id: "Word Section",
        key: regxKey,
        title: "Word Input",
        description: "Enter a Word here to test against your DFA. "
            "The simulator will check if the DFA accepts the given Word.",
        position: CustomTargetContentPosition(top: 80, right: 500),
        alignment: Alignment.topRight,
      ),
      _buildTutorialStep(
        id: "Info Section",
        key: infoPanelKey,
        title: "DFA Information / Table",
        description:
            "This panel provides detailed information about DFAs and their properties. "
            "It's a great resource for learning more about automata theory.",
        position: CustomTargetContentPosition(top: 300, right: 500),
        alignment: Alignment.centerRight,
      ),
      _buildTutorialStep(
        id: "Control Panel",
        key: controlPanelKey,
        title: "Simulation Control Panel",
        description:
            "Use these controls to run, pause, and reset the simulation. "
            "You can also step through the simulation one state at a time.",
        position: CustomTargetContentPosition(bottom: 150),
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
}
