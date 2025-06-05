import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:provider/provider.dart';

class EnterWordWidget extends StatefulWidget {
  const EnterWordWidget({super.key});

  @override
  EnterWordWidgetState createState() => EnterWordWidgetState();
}

class EnterWordWidgetState extends State<EnterWordWidget> {
  late DFA automatonModel;
  bool showInputField = false;
  final TextEditingController textController = TextEditingController();
  String inputText = "";

  @override
  void initState() {
    super.initState();
    automatonModel = Provider.of<DFA>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: showInputField
            ? Column(
                key: const ValueKey('input'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter word to check',
                      hintStyle: GoogleFonts.poppins(
                          color: Colors.deepPurple[200], fontSize: 16),
                      filled: true,
                      fillColor: Colors.deepPurple[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.deepPurple.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    style: GoogleFonts.roboto(
                        fontSize: 17, color: Colors.deepPurple[900]),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          inputText = textController.text;
                          automatonModel.word = inputText;
                          showInputField = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[700],
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                key: const ValueKey('show'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    inputText.isEmpty
                        ? 'Please enter a word to begin'
                        : inputText,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: inputText.isEmpty
                          ? Colors.deepPurple.shade200
                          : Colors.deepPurple.shade700,
                      fontWeight:
                          inputText.isEmpty ? FontWeight.w400 : FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          showInputField = true;
                          textController.text = inputText;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple[700],
                        side: BorderSide(color: Colors.deepPurple.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Text(
                        inputText.isEmpty ? 'Enter Word' : 'Edit Word',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
