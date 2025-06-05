import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/DFA/info/dfa_welcom_popup.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'widgets/editor_panel.dart';
import 'widgets/right_panel.dart';
import 'widgets/dfa_tutorial.dart';

class DfaPage extends StatefulWidget {
  const DfaPage({super.key});

  @override
  State<DfaPage> createState() => _DfaPageState();
}

class _DfaPageState extends State<DfaPage> {
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
      showDfaTutorial(
        context: context,
        editorKey: editorKey,
        regxKey: regxKey,
        infoPanelKey: infoPanelKey,
        controlPanelKey: controlPanelKey,
      );
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
              _buildCustomHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWideScreen = constraints.maxWidth > 800;
                    return Flex(
                      direction:
                          isWideScreen ? Axis.horizontal : Axis.vertical,
                      children: [
                        EditorPanel(
                          simulator: simulator,
                          editorKey: editorKey,
                          controlPanelKey: controlPanelKey,
                        ),
                        RightPanel(
                          regxKey: regxKey,
                          infoPanelKey: infoPanelKey,
                        ),
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

  Widget _buildCustomHeader() {
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
                showDfaTutorial(
                  context: context,
                  editorKey: editorKey,
                  regxKey: regxKey,
                  infoPanelKey: infoPanelKey,
                  controlPanelKey: controlPanelKey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
