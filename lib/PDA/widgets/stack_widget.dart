import 'package:flutter/material.dart';

class StackWidget extends StatefulWidget {
  const StackWidget({super.key});

  @override
  _StackWidgetState createState() => _StackWidgetState();
}

class _StackWidgetState extends State<StackWidget> {
  List<String> _stack = [];

  void _showInputDialog() {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter a word'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Word',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                final inputWord = textController.text.trim();
                if (inputWord.isNotEmpty) {
                  setState(() {
                    _stack.addAll(inputWord.split(''));
                  });
                  Navigator.of(context)
                      .pop(); // Close the dialog after submission
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        border: Border.all(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Stack',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline,
                      color: Colors.deepPurple[800]),
                  onPressed: _showInputDialog,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              reverse: true, // Start the scroll view from the bottom
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _buildStackVisualization(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStackVisualization() {
    if (_stack.isEmpty) {
      return [
        Text(
          'The stack is empty.',
          style: TextStyle(
            fontSize: 14, // Reduced font size
            color: Colors.deepPurple[800],
          ),
        ),
      ];
    }

    List<Widget> stackItems = [];
    for (int i = _stack.length - 1; i >= 0; i--) {
      stackItems.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1.0), // Reduced margin
          padding: const EdgeInsets.all(4.0), // Reduced padding
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
                fontSize: 14, // Reduced font size
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
