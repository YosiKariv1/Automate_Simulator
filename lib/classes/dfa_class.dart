import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:automaton_simulator/classes/node_class.dart';
import 'package:automaton_simulator/classes/transition_class.dart';
import 'package:automaton_simulator/DFA/pages/widgets/transition_symbol_popup.dart';

class DFA extends ChangeNotifier {
  List<Node> nodes = [];
  List<Transition> transitions = [];
  Transition? tempTransition;
  String word = '';
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
    word = regex;
    notifyListeners();
  }

  String getRegularExpression() {
    return word;
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
            existingTransition.updateSymbols(result);
          } else {
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

      tempTransition = null;
      currentMousePosition = null;
      notifyListeners();
    }
  }

  void printAutomatonInfo() {
    String alphabetString = alphabet;

    if (kDebugMode) {
      print("Alphabet: $alphabetString");
    }

    for (var node in nodes) {
      if (kDebugMode) {
        print('Node: ${node.name}');
      }

      String usedSymbols = '';
      for (var transition in transitions) {
        if (transition.from == node) {
          if (kDebugMode) {
            print(
                '  Transition to ${transition.to.name} with symbols: ${transition.symbol.join(', ')}');
          }
          for (var symbol in transition.symbol) {
            usedSymbols += symbol;
          }
        }
      }

      usedSymbols = String.fromCharCodes(usedSymbols.runes.toList()..sort());
      if (kDebugMode) {
        print('  Symbols used in transitions: $usedSymbols');
      }

      String missingSymbols = '';
      for (var symbol in alphabetString.split('')) {
        if (!usedSymbols.contains(symbol)) {
          missingSymbols += symbol;
        }
      }

      if (missingSymbols.isNotEmpty) {
        if (kDebugMode) {
          print('  Missing symbols for this node: $missingSymbols');
        }
      } else {
        if (kDebugMode) {
          print('  No missing symbols for this node');
        }
      }

      if (kDebugMode) {
        print('----------------------------------------------');
      }
    }
  }

  void reset() {
    nodes.clear();
    transitions.clear();
    tempTransition = null;
    word = '';
    currentMousePosition = null;
    alphabet = '';
    notifyListeners();
  }
}
