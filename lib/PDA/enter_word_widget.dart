import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/PDA/widgets/stack_widget.dart';
import 'package:myapp/PDA/editor_widget.dart';
import 'package:myapp/classes/pda_class.dart';
import 'package:provider/provider.dart';

class PdaPage extends StatefulWidget {
  const PdaPage({super.key});

  @override
  PdaPageState createState() => PdaPageState();
}

class PdaPageState extends State<PdaPage> {
  late PDA automaton;
  final TextEditingController inputController = TextEditingController();

  final GlobalKey editorKey = GlobalKey();
  final GlobalKey controlPanelKey = GlobalKey();
  final GlobalKey stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    automaton = Provider.of<PDA>(context, listen: false);
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
            'PDA Simulator',
            style: GoogleFonts.rajdhani(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // This can be used for future information or help features.
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
                    child: Container(
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
                      child: const PDAEditorWidget(),
                    ),
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
                  BoxShadow(color: Colors.black26, blurRadius: 10.0),
                ],
              ),
              child: const Center(
                child: Text('Simulation Control Panel'),
              ),
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
          buildEnterWordWidget(), // כאן הכנסנו את הווידג'ט החדש
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                key: stackKey,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                child: const StackWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEnterWordWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: inputController,
            decoration: InputDecoration(
              labelText: 'Enter a word to push to stack',
              labelStyle: TextStyle(color: Colors.deepPurple.shade700),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple.shade700),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final inputWord = inputController.text.trim();
              if (inputWord.isNotEmpty) {
                for (var char in inputWord.split('')) {
                  automaton.pushToStack(char);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
