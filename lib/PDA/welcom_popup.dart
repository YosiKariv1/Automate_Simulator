import 'package:flutter/material.dart';

class PDWelcomeDialog extends StatelessWidget {
  const PDWelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AlertDialog(
        backgroundColor: Colors.deepPurple.shade50,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Welcome to the Pushdown Automaton Simulator!',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.deepPurple[800], fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  'The Pushdown Automaton (PDA) is a powerful computational model that extends finite automata with a stack.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepPurple[800]),
                ),
                const SizedBox(height: 20),
                Text(
                  'PDAs are used to recognize Context-Free Languages, which include many natural languages and programming languages.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepPurple[800]),
                ),
                const SizedBox(height: 20),
                Text(
                  'With this simulator, you\'ll see how the PDA uses its stack to remember context and make decisions. It\'s a great way to learn about parsing and syntactic analysis!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.deepPurple[900],
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.explore, color: Colors.white),
                  label: const Text('Let\'s Begin!',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Tip: PDAs are the basis for understanding how compilers and interpreters process programming languages!',
                  style: TextStyle(
                      color: Colors.deepPurple[300],
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showPDWelcomeDialog(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: const PDWelcomeDialog(),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
