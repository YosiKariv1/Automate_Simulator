import 'package:flutter/material.dart';
import 'package:myapp/classes/automaton_class.dart';
import 'package:provider/provider.dart';

class WelcomeDialog extends StatelessWidget {
  WelcomeDialog({super.key});

  final TextEditingController sigmaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final automaton = Provider.of<Automaton>(context, listen: false);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: AlertDialog(
        backgroundColor: Colors.deepPurple.shade50,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Welcome to the World of Automata!',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.deepPurple.shade700, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                'Automata are foundational models in computer science. Understanding them can deepen your knowledge of computation.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple.shade700),
              ),
              const SizedBox(height: 20),
              Text(
                'Let\'s create our alphabet:',
                style: TextStyle(
                    color: Colors.deepPurple.shade900,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: sigmaController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Enter alphabet symbols (e.g., a,b,0,1)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  prefixIcon:
                      Icon(Icons.abc, color: Colors.deepPurple.shade700),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.rocket_launch, color: Colors.white),
                label: const Text('Let\'s Go!',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple.shade700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  String input = sigmaController.text.trim();
                  if (input.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('The alphabet cannot be empty!')),
                    );
                  } else {
                    // Split the input into individual characters, remove spaces and duplicates
                    Set<String> alphabetSet = input
                        .split(',')
                        .where((e) => e.trim().isNotEmpty)
                        .toSet();
                    String alphabet = alphabetSet.join();

                    if (alphabet.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'No valid characters found in the alphabet!')),
                      );
                    } else {
                      automaton.setAlphabet(alphabet);
                      Navigator.of(context).pop(
                          true); // Return true when dialog is closed successfully
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Tip: The alphabet defines all possible symbols that the automaton can read.',
                style: TextStyle(
                    color: Colors.deepPurple.shade300,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showWelcomeDialog(BuildContext context) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: Center(
          child: SizedBox(
            width: 500, // רוחב הפופ-אפ שונה ל-500 פיקסלים
            child: WelcomeDialog(),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
  return result ??
      false; // Return false if the dialog was dismissed without pressing the button
}
