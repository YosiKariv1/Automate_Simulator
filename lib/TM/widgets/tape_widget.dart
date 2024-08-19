import 'package:flutter/material.dart';
import 'package:myapp/classes/tape_class.dart';
import 'package:myapp/classes/turing_machine_class.dart';
import 'package:provider/provider.dart';

class TapeWidget extends StatefulWidget {
  const TapeWidget({super.key});

  @override
  TapeWidgetState createState() => TapeWidgetState();
}

class TapeWidgetState extends State<TapeWidget> {
  final List<FocusNode> focusNodes = List.generate(25, (index) => FocusNode());

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TuringMachine>(
      builder: (context, turingMachine, child) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Colors.deepPurple.shade500,
              width: 4.0,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10.0),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    turingMachine.cells.length,
                    (index) => buildTapeCell(turingMachine, index),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildControlButton(turingMachine, Icons.arrow_left, 'left'),
                  const SizedBox(width: 8),
                  buildControlButton(turingMachine, Icons.delete, 'delete'),
                  const SizedBox(width: 8),
                  buildControlButton(turingMachine, Icons.arrow_right, 'right'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTapeCell(TuringMachine turingMachine, int index) {
    TapeCell cell = turingMachine.cells[index];
    bool isHead = cell.isHead;
    bool isError = cell.isError; // נשתמש במשתנה זה

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.all(4.0),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isError
                ? Colors.red[50]
                : Colors.deepPurple[50], // אם יש שגיאה צבע אדום
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isHead
                  ? Colors.deepPurple
                  : (isError ? Colors.red : Colors.deepPurple[800]!),
              width: isHead ? 3.0 : 1.0,
            ),
          ),
          child: Center(
            child: TextField(
              focusNode: focusNodes[index],
              onChanged: (text) {
                turingMachine.updateTapeContent(index, text);
                if (text.isNotEmpty &&
                    text.length == 1 &&
                    index < turingMachine.cells.length - 1) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                }
              },
              controller: TextEditingController(
                text: cell.content,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isError ? Colors.red : Colors.deepPurple[800],
              ),
              maxLength: 1,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
              ),
            ),
          ),
        ),
        if (isHead)
          const Positioned(
            top: -15,
            child: Icon(
              Icons.arrow_drop_down,
              size: 50,
              color: Color.fromARGB(255, 94, 5, 112),
            ),
          ),
      ],
    );
  }

  Widget buildControlButton(
      TuringMachine turingMachine, IconData icon, String action) {
    return ElevatedButton(
      onPressed: () {
        if (action == 'delete') {
          turingMachine.resetTape();
        } else {
          turingMachine.moveHead(action.toLowerCase());
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.deepPurple[600],
        padding: const EdgeInsets.all(12.0),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
