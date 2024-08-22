import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PDATransitionPopup extends StatefulWidget {
  final String alphabet;
  final Set<String> initialSymbols;
  final Set<String> usedSymbols;

  const PDATransitionPopup({
    Key? key,
    required this.alphabet,
    required this.initialSymbols,
    required this.usedSymbols,
  }) : super(key: key);

  @override
  PDATransitionPopupState createState() => PDATransitionPopupState();
}

class PDATransitionPopupState extends State<PDATransitionPopup> {
  late Set<String> selectedSymbols;
  String currentState = '';
  String stackTopSymbol = '';
  String inputSymbol = '';

  @override
  void initState() {
    super.initState();
    selectedSymbols = Set.from(widget.initialSymbols);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "PDA Transition",
              style: GoogleFonts.rajdhani(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            buildTextField(
              label: "Current State",
              value: currentState,
              onChanged: (value) {
                setState(() {
                  currentState = value;
                });
              },
            ),
            const SizedBox(height: 12),
            buildTextField(
              label: "Stack Top Symbol",
              value: stackTopSymbol,
              onChanged: (value) {
                setState(() {
                  stackTopSymbol = value;
                });
              },
            ),
            const SizedBox(height: 12),
            buildTextField(
              label: "Input Symbol",
              value: inputSymbol,
              onChanged: (value) {
                setState(() {
                  inputSymbol = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Text(
              "Select Symbols to Push onto Stack",
              style: GoogleFonts.rajdhani(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepPurple[200]!),
              ),
              child: Text(
                selectedSymbols.isEmpty
                    ? 'No symbols selected'
                    : selectedSymbols.join(', '),
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.deepPurple[800],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: widget.alphabet.split('').map((letter) {
                bool isSelected = selectedSymbols.contains(letter);
                bool isUsed = widget.usedSymbols.contains(letter);
                return SizedBox(
                  width: 45,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          isSelected ? Colors.white : Colors.deepPurple[800],
                      backgroundColor: isSelected
                          ? Colors.deepPurple[600]
                          : isUsed
                              ? Colors.grey[300]
                              : Colors.deepPurple[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: isUsed
                        ? null
                        : () {
                            setState(() {
                              if (isSelected) {
                                selectedSymbols.remove(letter);
                              } else {
                                selectedSymbols.add(letter);
                              }
                            });
                          },
                    child: Text(
                      letter,
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 61, 43, 97),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: selectedSymbols.isNotEmpty
                        ? () => Navigator.of(context).pop({
                              'currentState': currentState,
                              'stackTopSymbol': stackTopSymbol,
                              'inputSymbol': inputSymbol,
                              'pushSymbols': selectedSymbols,
                            })
                        : null,
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple[800],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.deepPurple[800]!),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.rajdhani(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.deepPurple),
            ),
            filled: true,
            fillColor: Colors.deepPurple[50],
          ),
        ),
      ],
    );
  }
}
