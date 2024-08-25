import 'package:flutter/material.dart';
import 'package:myapp/PDA/tansition_popup.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/operations_class.dart';
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
    tempTransition = Transition(from: fromNode, to: fromNode);
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

        Transition? existingTransition;
        for (var t in transitions) {
          if (t.from == tempTransition!.from && t.to == targetNode) {
            existingTransition = t;
            break;
          }
        }

        final result = await showDialog<List<Operations>>(
          context: context,
          builder: (BuildContext context) {
            return PDATransitionPopup(
              initialOperations: existingTransition?.operations ?? [],
            );
          },
        );

        if (result != null && result.isNotEmpty) {
          if (existingTransition != null) {
            existingTransition.setOperations(result);
          } else {
            Transition newTransition = Transition(
              from: tempTransition!.from,
              to: targetNode,
            );

            newTransition.setOperations(result);
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

  void printPDAState() {
    print('Current word: $word');
    print('Stack content: ${pdaStack.stack}');

    print('Nodes:');
    for (var node in nodes) {
      print(
          ' - Node ${node.name}: isStart=${node.isStart}, isAccepting=${node.isAccepting}');
    }

    print('Transitions:');
    for (var transition in transitions) {
      print(
          ' - Transition from Node ${transition.from.name} to Node ${transition.to.name}');
      print('   Operations:');
      for (var operation in transition.operations) {
        print(
            '     Input: ${operation.inputTopSymbol}, Stack Pop: ${operation.stackPopSymbol}, Stack Push: ${operation.stackPushSymbol}');
      }
    }
  }
}
