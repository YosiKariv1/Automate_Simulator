import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/transition_class.dart';
import 'package:myapp/DFA/pages/widgets/transition_symbol_popup.dart';

class DFA extends ChangeNotifier {
  List<Node> nodes = [];
  List<Transition> transitions = [];
  Transition? tempTransition;
  String regularExp = '';
  Offset? currentMousePosition;
  String alphabet = '';

  void setAlphabet(String newAlphabet) {
    alphabet = newAlphabet;
    notifyListeners();
  }

  String getAlphabet() {
    return alphabet;
  }

  void setRegularExpression(String regex) {
    regularExp = regex;
    notifyListeners();
  }

  String getRegularExpression() {
    return regularExp;
  }

  void addNode(Node node) {
    if (nodes.isEmpty) {
      node.isStart = true;
    } else {
      node.isStart = false;
    }
    nodes.add(node);
    notifyListeners();
  }

  void removeNode() {
    if (nodes.isNotEmpty) {
      Node nodeToDelete = nodes.last;
      transitions.removeWhere((transition) =>
          transition.from == nodeToDelete || transition.to == nodeToDelete);
      nodes.removeLast();
      notifyListeners();
      if (kDebugMode) {
        print(
            'Deleted node: ${nodeToDelete.name} and its associated transitions');
      }
    } else {
      if (kDebugMode) {
        print('No nodes to delete');
      }
    }
  }

  Node? findNodeAtPosition(Offset position) {
    for (var node in nodes) {
      if ((position - node.leftSideNode).distance <= 30) {
        return node;
      }
    }
    return null;
  }

  void startTransition(Node fromNode, Offset fromOffset) {
    tempTransition = Transition(from: fromNode, to: fromNode, symbol: {});
    notifyListeners();
  }

  void updateTransition(Offset currentOffset) {
    currentMousePosition = currentOffset;
    notifyListeners();
  }

  Future<void> endTransition(
      Node node, Offset currentOffset, BuildContext context) async {
    if (tempTransition != null) {
      Node? targetNode = findNodeAtPosition(currentOffset);
      if (targetNode != null) {
        tempTransition!.to = targetNode;

        // Check if a transition already exists between these nodes
        Transition? existingTransition;
        for (var t in transitions) {
          if (t.from == tempTransition!.from && t.to == targetNode) {
            existingTransition = t;
            break;
          }
        }

        Set<String> usedSymbols = transitions
            .where((t) => t.from == tempTransition!.from && t != tempTransition)
            .expand((t) => t.symbol)
            .toSet();

        final Set<String>? result = await showDialog<Set<String>>(
          context: context,
          builder: (BuildContext context) {
            return TransitionSymbolPopup(
              alphabet: alphabet,
              initialSymbols: existingTransition?.symbol ?? {},
              usedSymbols: usedSymbols,
            );
          },
        );

        if (result != null && result.isNotEmpty) {
          if (existingTransition != null) {
            // Update existing transition
            existingTransition.updateSymbols(result);
          } else {
            // Create new transition
            Transition newTransition = Transition(
              from: tempTransition!.from,
              to: targetNode,
              symbol: result,
            );
            transitions.add(newTransition);
          }
          notifyListeners();
        }
      }

      // Clear temporary transition and mouse position
      tempTransition = null;
      currentMousePosition = null;
      notifyListeners();
    }
  }

  void printAutomatonInfo() {
    // המרת האלפבית למחרוזת אחת לצורך השוואות קלות יותר
    String alphabetString = alphabet;

    print("Alphabet: $alphabetString");

    for (var node in nodes) {
      print('Node: ${node.name}');

      // איסוף כל הסימבולים המשומשים במעברים מהצומת הנוכחי
      String usedSymbols = '';
      for (var transition in transitions) {
        if (transition.from == node) {
          print(
              '  Transition to ${transition.to.name} with symbols: ${transition.symbol.join(', ')}');
          for (var symbol in transition.symbol) {
            usedSymbols += symbol;
          }
        }
      }

      // המרת הסימבולים המשומשים למחרוזת אחת ולמיין
      usedSymbols = String.fromCharCodes(usedSymbols.runes.toList()..sort());
      print('  Symbols used in transitions: $usedSymbols');

      // מציאת סימבולים חסרים מהאלפבית
      String missingSymbols = '';
      for (var symbol in alphabetString.split('')) {
        if (!usedSymbols.contains(symbol)) {
          missingSymbols += symbol;
        }
      }

      if (missingSymbols.isNotEmpty) {
        print('  Missing symbols for this node: $missingSymbols');
      } else {
        print('  No missing symbols for this node');
      }

      print('----------------------------------------------');
    }
  }

  void reset() {
    nodes.clear();
    transitions.clear();
    tempTransition = null;
    regularExp = '';
    currentMousePosition = null;
    alphabet = '';
    notifyListeners();
  }
}
