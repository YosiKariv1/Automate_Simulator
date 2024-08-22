import 'package:flutter/material.dart';
import 'package:myapp/classes/dfa_class.dart';

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
      final snackBar = SnackBar(
        content: Text(messages.join('\n')),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    return true;
  }
}
