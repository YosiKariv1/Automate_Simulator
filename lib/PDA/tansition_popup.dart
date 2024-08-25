import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PDATransitionPopup extends StatefulWidget {
  final String alphabet;
  final Set<String> initialSymbols;
  final Set<String> usedSymbols;

  const PDATransitionPopup({
    super.key,
    required this.alphabet,
    required this.initialSymbols,
    required this.usedSymbols,
  });

  @override
  PDATransitionPopupState createState() => PDATransitionPopupState();
}

class PDATransitionPopupState extends State<PDATransitionPopup> {
  late Set<String> selectedSymbols;
  String stackPeakSymbol = '';
  String inputSymbol = '';
  String stackPushSymbol = '';

  @override
  void initState() {
    super.initState();
    selectedSymbols = Set.from(widget.initialSymbols);
  }

  bool _isConfirmEnabled() {
    return stackPeakSymbol.isNotEmpty &&
        inputSymbol.isNotEmpty &&
        stackPushSymbol.isNotEmpty &&
        selectedSymbols.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
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
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: "Stack Peak Symbol",
              value: stackPeakSymbol,
              onChanged: (value) {
                setState(() {
                  stackPeakSymbol = value;
                });
              },
            ),
            const SizedBox(height: 16),
            buildTextField(
              label: "Input Symbol",
              value: inputSymbol,
              onChanged: (value) {
                setState(() {
                  inputSymbol = value;
                });
              },
            ),
            const SizedBox(height: 16),
            buildTextField(
              label: "Stack Push Symbol",
              value: stackPushSymbol,
              onChanged: (value) {
                setState(() {
                  stackPushSymbol = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: widget.alphabet.split('').map((letter) {
                bool isSelected = selectedSymbols.contains(letter);
                bool isUsed = widget.usedSymbols.contains(letter);
                return SizedBox(
                  width: 50,
                  height: 50,
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
                      elevation: 5,
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
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: _isConfirmEnabled()
                        ? () => Navigator.of(context).pop({
                              'stackPeakSymbol': stackPeakSymbol,
                              'inputSymbol': inputSymbol,
                              'stackPushSymbol': stackPushSymbol,
                              'pushSymbols': selectedSymbols,
                            })
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isConfirmEnabled() ? Colors.deepPurple : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: _isConfirmEnabled() ? 5 : 0,
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple[800],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.deepPurple[800]!),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.roboto(fontSize: 18),
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 120,
            height: 48,
            child: TextField(
              onChanged: onChanged,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.deepPurple[800],
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                counterText: '',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.deepPurple),
                ),
                filled: true,
                fillColor: Colors.deepPurple[50],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
