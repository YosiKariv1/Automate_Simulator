import 'package:flutter/material.dart';
import 'package:myapp/PDA/tansition_popup.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/transition_class.dart';
import 'package:myapp/classes/stack_class.dart';

class PDA extends ChangeNotifier {
  List<Node> nodes = [];
  List<Transition> transitions = [];
  Transition? tempTransition;
  String alphabet = '';
  String word = '';
  Offset? currentMousePosition;
  final PDAStack pdaStack = PDAStack();

  void setAlphabet(String newAlphabet) {
    alphabet = newAlphabet;
    notifyListeners();
  }

  String getAlphabet() {
    return alphabet;
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
            return PDATransitionPopup(
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

  void pushToStack(String symbol) {
    pdaStack.push(symbol);
    notifyListeners();
  }

  String? popFromStack() {
    final symbol = pdaStack.pop();
    notifyListeners();
    return symbol;
  }

  String? peekStack() {
    return pdaStack.peek();
  }

  void reset() {
    nodes.clear();
    transitions.clear();
    tempTransition = null;
    alphabet = '';
    pdaStack.reset();
    notifyListeners();
  }
}
