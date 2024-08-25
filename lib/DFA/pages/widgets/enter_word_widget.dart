import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/classes/dfa_class.dart';
import 'package:myapp/DFA/info/regex_info.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Input Word',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const RegexInfoPopup();
                    },
                  );
                },
                icon: const Icon(Icons.info_outline, color: Colors.white),
              ),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: showInputField
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: 'Enter Word To check',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          style: GoogleFonts.roboto(),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              inputText = textController.text;
                              automatonModel.word = inputText;
                              showInputField = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Submit', style: GoogleFonts.poppins()),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          inputText.isEmpty ? 'No word are entered' : inputText,
                          style: GoogleFonts.roboto(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showInputField = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Enter Expression',
                              style: GoogleFonts.poppins()),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
