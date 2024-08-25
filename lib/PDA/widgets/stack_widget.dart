import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:myapp/classes/pda_class.dart';

class StackWidget extends StatefulWidget {
  const StackWidget({super.key});

  @override
  StackWidgetState createState() => StackWidgetState();
}

class StackWidgetState extends State<StackWidget> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pda = context.watch<PDA>();

    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: pda.pdaStack.stack.isEmpty
                ? Center(
                    child: Text(
                      'The stack is empty.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: _buildStackVisualization(pda),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Enter text to push',
                    hintStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                  ),
                  style: GoogleFonts.poppins(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final inputWord = textController.text.trim();
                  if (inputWord.isNotEmpty) {
                    for (var letter in inputWord.split('')) {
                      pda.pushToStack(letter);
                    }
                    textController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Push', style: GoogleFonts.poppins()),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  pda.popFromStack();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple[900],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Pop', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStackVisualization(PDA pda) {
    List<Widget> stackItems = [];
    for (int i = pda.pdaStack.stack.length - 1; i >= 0; i--) {
      stackItems.add(
        Dismissible(
          key: ValueKey(pda.pdaStack.stack[i] + i.toString()),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            if (i == pda.pdaStack.stack.length - 1) {
              pda.popFromStack();
            }
          },
          background: Container(
            alignment: Alignment.centerLeft,
            color: Colors.deepPurple[900],
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 1.0),
            padding: const EdgeInsets.all(4.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: i == pda.pdaStack.stack.length - 1
                  ? Colors.blueAccent
                  : Colors.deepPurple[200],
              border: Border.all(color: Colors.deepPurple, width: 1),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: i == pda.pdaStack.stack.length - 1
                      ? Colors.blueAccent.withOpacity(0.5)
                      : Colors.deepPurple.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                pda.pdaStack.stack[i],
                style: TextStyle(
                  fontSize: 14,
                  color: i == pda.pdaStack.stack.length - 1
                      ? Colors.white
                      : Colors.deepPurple[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return stackItems;
  }
}
