import 'package:flutter/material.dart';

class TuringWelcomeDialog extends StatelessWidget {
  const TuringWelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AlertDialog(
        backgroundColor: Colors.deepPurple.shade50,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Welcome to the Turing Machine Simulator!',
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
                  'The Turing Machine is a fascinating concept created by Alan Turing in 1936.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepPurple[800]),
                ),
                const SizedBox(height: 20),
                Text(
                  'This machine is not a physical one, but rather a thought experiment to understand the limits of what can be computed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepPurple[800]),
                ),
                const SizedBox(height: 20),
                Text(
                  'You\'re about to explore how a simple set of rules can simulate any computation. It\'s like magic, but real!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.deepPurple[900],
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.rocket_launch, color: Colors.white),
                  label: const Text('Let\'s Start!',
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
                  'Tip: The Turing Machine shows how the most basic operations can solve the most complex problems!',
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

Future<void> showTuringWelcomeDialog(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: const TuringWelcomeDialog(),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
