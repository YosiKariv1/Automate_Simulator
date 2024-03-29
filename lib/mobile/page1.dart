import 'package:automate_simulator/automate/controllers/automate_controller.dart';
import 'package:automate_simulator/mobile/automate_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SimpleInputPage extends StatefulWidget {
  const SimpleInputPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SimpleInputPageState createState() => _SimpleInputPageState();
}

class _SimpleInputPageState extends State<SimpleInputPage> {
  final TextEditingController _textController = TextEditingController();
  AutomateController automateController = AutomateController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automate Setting Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Enter alphabet',
              border: OutlineInputBorder(),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          automateController.model.alphabet = _textController.text.split('');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AutomateEditorMobile(
                    automatonController: automateController,
                  )));
          if (kDebugMode) {
            print('Next button pressed with text: ${_textController.text}');
            print('The alphabet text is: ${automateController.model.alphabet}');
          }
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
