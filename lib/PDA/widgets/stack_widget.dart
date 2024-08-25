import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StackWidget extends StatefulWidget {
  const StackWidget({super.key});

  @override
  StackWidgetState createState() => StackWidgetState();
}

class StackWidgetState extends State<StackWidget> {
  final List<String> _stack = [];
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: _stack.isEmpty
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
                            children: _buildStackVisualization(),
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
                    setState(() {
                      _stack.addAll(inputWord.split(''));
                      textController.clear();
                    });
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
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStackVisualization() {
    List<Widget> stackItems = [];
    for (int i = _stack.length - 1; i >= 0; i--) {
      stackItems.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1.0),
          padding: const EdgeInsets.all(4.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: i == _stack.length - 1
                ? Colors.blueAccent
                : Colors.deepPurple[200],
            border: Border.all(color: Colors.deepPurple, width: 1),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: i == _stack.length - 1
                    ? Colors.blueAccent.withOpacity(0.5)
                    : Colors.deepPurple.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _stack[i],
              style: TextStyle(
                fontSize: 14,
                color: i == _stack.length - 1
                    ? Colors.white
                    : Colors.deepPurple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return stackItems;
  }
}
