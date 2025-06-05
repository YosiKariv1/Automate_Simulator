import 'package:flutter/material.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AutomatonValidator {
  static bool validateAndNotify(BuildContext context, DFA automaton) {
    String alphabetString = automaton.alphabet;
    List<String> messages = [];
    bool hasAcceptingState = automaton.nodes.any((node) => node.isAccepting);

    if (!hasAcceptingState) {
      messages.add('There are no accepting states.');
    }

    for (var node in automaton.nodes) {
      String usedSymbols = '';
      for (var transition in automaton.transitions) {
        if (transition.from == node) {
          for (var symbol in transition.symbol) {
            usedSymbols += symbol;
          }
        }
      }

      usedSymbols = String.fromCharCodes(usedSymbols.runes.toList()..sort());

      String missingSymbols = '';
      for (var symbol in alphabetString.split('')) {
        if (!usedSymbols.contains(symbol)) {
          missingSymbols += symbol;
        }
      }

      if (missingSymbols.isNotEmpty) {
        messages.add('Node ${node.name} is missing symbols: $missingSymbols');
        node.setError(true);
      }
    }

    if (messages.isNotEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 100),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: messages.map((message) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.circleInfo,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              message,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        displayDuration: const Duration(seconds: 5),
        animationDuration: const Duration(milliseconds: 500),
      );

      return false;
    }

    return true;
  }
}
