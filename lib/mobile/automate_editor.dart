import 'package:automate_simulator/automate/controllers/automate_controller.dart';
import 'package:flutter/material.dart';
import 'package:automate_simulator/mobile/widgets/floating_buttons.dart';

class AutomateEditorMobile extends StatefulWidget {
  final AutomateController automatonController;

  const AutomateEditorMobile({super.key, required this.automatonController});

  @override
  State<AutomateEditorMobile> createState() => _AutomateEditorMobileState();
}

class _AutomateEditorMobileState extends State<AutomateEditorMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 205, 240, 159),
      floatingActionButton: FloatingButtons(
        addNode: addNode,
        deleteNode: deleteNode,
        playAction: () {
          // Implement or trigger simulation/play action
        },
        onBack: () {
          Navigator.pop(context);
        },
        onInfo: info,
      ),
      body: widget.automatonController.widget,
    );
  }

  void addNode() {
    setState(() {
      widget.automatonController.addNode();
    });
  }

  void deleteNode() {
    setState(() {
      widget.automatonController.deleteNode();
    });
  }

  void info() {
    setState(() {
      // Implement or trigger info action
    });
  }
}
