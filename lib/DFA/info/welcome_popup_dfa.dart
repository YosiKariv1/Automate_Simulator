import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeDialogDFA extends StatelessWidget {
  WelcomeDialogDFA({super.key});

  final TextEditingController sigmaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final automaton = Provider.of<DFA>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //-------------------- HEADER --------------------\\
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF6C3EC1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
          child: Text(
            'Welcome to the World of Automata!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
              letterSpacing: 0.2,
            ),
          ),
        ),

        //-------------------- MAIN CONTENT --------------------\\
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Automata are foundational models in computer science. Understanding them can deepen your knowledge of computation.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Let's create our alphabet:",
                style: GoogleFonts.poppins(
                  color: Colors.deepPurple.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: sigmaController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Enter alphabet symbols (e.g., a,b,0,1)',
                    labelStyle: TextStyle(color: Colors.deepPurple.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.deepPurple.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          color: Colors.deepPurple.shade700, width: 2),
                    ),
                    prefixIcon:
                        Icon(Icons.abc, color: Colors.deepPurple.shade700),
                    hintText: 'e.g., a,b,0,1',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                  cursorColor: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.rocket_launch,
                      color: Colors.white, size: 24),
                  label: Text(
                    'Let\'s Go!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    elevation: 8,
                  ),
                  onPressed: () {
                    String input = sigmaController.text.trim();
                    if (input.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('The alphabet cannot be empty!',
                              textAlign: TextAlign.center),
                        ),
                      );
                    } else {
                      Set<String> alphabetSet = input
                          .split(',')
                          .where((e) => e.trim().isNotEmpty)
                          .toSet();
                      String alphabet = alphabetSet.join();
                      if (alphabet.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'No valid characters found in the alphabet!',
                                textAlign: TextAlign.center),
                          ),
                        );
                      } else {
                        automaton.setAlphabet(alphabet);
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 420,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 20, color: Colors.deepPurple.shade400),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tip: The alphabet defines all possible symbols that the automaton can read.',
                          style: GoogleFonts.poppins(
                            color: Colors.deepPurple.shade400,
                            fontStyle: FontStyle.italic,
                            fontSize: 13.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<bool> showWelcomeDialog(BuildContext context) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Welcome Dialog",
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: Center(
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              width: 600,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 18,
                  ),
                ],
              ),
              child: WelcomeDialogDFA(),
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
  return result ?? false;
}
