import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:automaton_simulator/PDA/simulator/control_panel.dart';
import 'package:automaton_simulator/PDA/enter_word_widget.dart';
import 'package:automaton_simulator/PDA/simulator/pda_simulator.dart';
import 'package:automaton_simulator/PDA/simulator/word_display_widget.dart';
import 'package:automaton_simulator/PDA/welcom_popup.dart';
import 'package:automaton_simulator/PDA/widgets/stack_widget.dart';
import 'package:automaton_simulator/PDA/editor_widget.dart';
import 'package:automaton_simulator/classes/pda_class.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:automaton_simulator/common/widgets/custom_header.dart';

class PdaPage extends StatefulWidget {
  const PdaPage({super.key});

  @override
  PdaPageState createState() => PdaPageState();
}

class PdaPageState extends State<PdaPage> {
  late PDA automaton;
  late PDASimulator simulator;

  final GlobalKey editorKey = GlobalKey();
  final GlobalKey stackKey = GlobalKey();
  final GlobalKey controlPanelKey = GlobalKey();
  final GlobalKey inputWordKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    automaton = Provider.of<PDA>(context, listen: false);
    simulator = PDASimulator(automaton);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showPDWelcomeDialog(context); // הצגת פופ-אפ ברוכים הבאים
      showTutorial(); // הצגת הדרכה
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
              CustomHeader(title: "PDA Simulator", onBack: () { automaton.reset(); Navigator.of(context).pop(); }, onHelp: () { showTutorial(); },),
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
                    child: AnimatedBuilder(
                      animation: simulator,
                      builder: (context, child) {
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
                              child: PDAEditorWidget(key: editorKey),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  AnimatedBuilder(
                    animation: simulator,
                    builder: (context, child) {
                      bool isSimulating = !simulator.algorithmFinished;
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        top: isSimulating ? 0 : -50,
                        left: 0,
                        right: 0,
                        height: 50,
                        child: PDAWordDisplayWidget(
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
          buildStackPanel(),
          buildSmallContainer(),
        ],
      ),
    );
  }

  Widget buildStackPanel() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Container(
          key: stackKey,
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
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
                      'Stack',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: StackWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSmallContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
      child: Container(
        height: 200,
        key: inputWordKey,
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          border: Border.all(color: Colors.deepPurple, width: 2),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
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
                    'Input Word',
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
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: EnterWordWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.deepPurple[900]!,
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
        "PDA Editor",
        "This is where you can create and edit your PDA (Pushdown Automaton). "
            "Add states, transitions, and stack operations to define your automaton's behavior.",
        CustomTargetContentPosition(left: 0, bottom: 0),
        width: 100,
        height: 100,
      ),
      _buildTutorialStep(
        "Stack Section",
        stackKey,
        "Stack Visualization",
        "This panel visualizes the stack used by the PDA. "
            "Watch how the stack evolves as you run the simulation.",
        CustomTargetContentPosition(left: 0, bottom: 50),
        width: 0,
        height: 100,
      ),
      _buildTutorialStep(
        "Input Word Section",
        inputWordKey,
        "Input Word",
        "Enter an input word here to test against your PDA. "
            "The simulator will process the input according to the PDA's rules.",
        CustomTargetContentPosition(left: 0, bottom: 250),
        width: 0,
        height: 100,
      ),
      _buildTutorialStep(
        "ControlPanel",
        controlPanelKey,
        "Simulation Control Panel",
        "Use these controls to run, pause, any time you want !. ",
        CustomTargetContentPosition(bottom: 100),
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
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 5),
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
