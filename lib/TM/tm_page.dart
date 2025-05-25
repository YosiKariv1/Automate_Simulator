import 'package:flutter/material.dart';
import 'package:automaton_simulator/TM/add_rule_widget.dart';
import 'package:automaton_simulator/TM/control_panel_widget.dart';
import 'package:automaton_simulator/TM/editor_widget.dart';
import 'package:automaton_simulator/TM/simulator/tm_simulator.dart';
import 'package:automaton_simulator/TM/welcome_popup.dart';
import 'package:automaton_simulator/TM/widgets/tape_widget.dart';
import 'package:automaton_simulator/classes/turing_machine_class.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:google_fonts/google_fonts.dart';

class TmPage extends StatefulWidget {
  const TmPage({super.key});

  @override
  TmPageState createState() => TmPageState();
}

class TmPageState extends State<TmPage> {
  late TuringMachine turingMachine;
  late TuringSimulator simulator;

  final GlobalKey tapeKey = GlobalKey();
  final GlobalKey addRuleKey = GlobalKey();
  final GlobalKey editorKey = GlobalKey();
  final GlobalKey controlPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    turingMachine = Provider.of<TuringMachine>(context, listen: false);
    simulator = TuringSimulator(turingMachine);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showTuringWelcomeDialog(context);
      showTutorial();
    });
  }

  void showTutorial() {
    TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.deepPurple[900]!,
      textSkip: "Skip Tutorial",
      textStyleSkip: GoogleFonts.poppins(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: false,
      alignSkip: Alignment.bottomRight,
      skipWidget: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepPurple[700],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text("Skip", style: TextStyle(color: Colors.white)),
      ),
    ).show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      _buildTutorialStep(
        "Tape Section",
        tapeKey,
        "Turing Machine Tape",
        "Here you can see the tape, which represents the memory of the Turing Machine. "
            "The tape consists of cells, each containing a single character. "
            "The read/write head moves along the tape and can read and modify the content of the cells.",
        ContentAlign.bottom,
      ),
      _buildTutorialStep(
        "AddRule Section",
        addRuleKey,
        "Add Rules",
        "Use this section to add rules to your Turing Machine. "
            "Each rule defines what the machine should do based on the current state and the character read from the tape. "
            "The rules determine the behavior of the machine.",
        ContentAlign.top,
      ),
      _buildTutorialStep(
        "Editor Section",
        editorKey,
        "Turing Machine Editor",
        "Here you can see a visual representation of your Turing Machine. "
            "States are represented as circles, and transitions between states are shown as arrows. "
            "This helps you understand the logic of your machine in a graphical way.",
        ContentAlign.top,
      ),
      _buildTutorialStep(
        "ControlPanel",
        controlPanelKey,
        "Simulation Control Panel",
        "This control panel allows you to control the simulation of the Turing Machine. "
            "You can play, pause any time you want!. ",
        ContentAlign.top,
      ),
    ];
  }

  TargetFocus _buildTutorialStep(
    String identify,
    GlobalKey key,
    String title,
    String description,
    ContentAlign align,
  ) {
    return TargetFocus(
      identify: identify,
      keyTarget: key,
      alignSkip: Alignment.topRight,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return Container(
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
                    style: GoogleFonts.poppins(
                      color: Colors.deepPurple,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style:
                        GoogleFonts.roboto(color: Colors.black87, fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      shape: ShapeLightFocus.RRect,
      radius: 10,
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TapeWidget(key: tapeKey),
                        const SizedBox(height: 8),
                        buildEditorArea(),
                        const SizedBox(height: 8),
                        AddRuleWidget(key: addRuleKey),
                        const SizedBox(height: 8),
                        TuringSimulationControlPanel(
                          simulator: simulator,
                          key: controlPanelKey,
                        ),
                      ],
                    ),
                  ),
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Text(
            'Turing Machine Simulator',
            style: GoogleFonts.rajdhani(
              fontSize: 32,
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

  Widget buildEditorArea() {
    return Container(
      key: editorKey,
      height: 370,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.deepPurple.shade500,
          width: 4.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: TmEditorWidget(turingMachine: turingMachine),
    );
  }
}
