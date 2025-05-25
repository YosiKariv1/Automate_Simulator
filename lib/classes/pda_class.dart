import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:automaton_simulator/PDA/tansition_popup.dart';
import 'package:automaton_simulator/classes/node_class.dart';
import 'package:automaton_simulator/classes/operations_class.dart';
import 'package:automaton_simulator/classes/transition_class.dart';
import 'package:automaton_simulator/classes/stack_class.dart';

class PDA extends ChangeNotifier {
  List<Node> nodes = [];
  List<Transition> transitions = [];
  Transition? tempTransition;
  String alphabet = '';
  String word = '';
  Offset? currentMousePosition;
  PDAStack pdaStack = PDAStack();

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
    if (kDebugMode) {
      print('Current word: $word');
    }
    if (kDebugMode) {
      print('Stack content: ${pdaStack.stack}');
    }

    if (kDebugMode) {
      print('Nodes:');
    }
    for (var node in nodes) {
      if (kDebugMode) {
        print(
            ' - Node ${node.name}: isStart=${node.isStart}, isAccepting=${node.isAccepting}');
      }
    }

    if (kDebugMode) {
      print('Transitions:');
    }
    for (var transition in transitions) {
      if (kDebugMode) {
        print(
            ' - Transition from Node ${transition.from.name} to Node ${transition.to.name}');
      }
      if (kDebugMode) {
        print('   Operations:');
      }
      for (var operation in transition.operations) {
        if (kDebugMode) {
          print(
              '     Input: ${operation.inputTopSymbol}, Stack Pop: ${operation.stackPopSymbol}, Stack Push: ${operation.stackPushSymbol}');
        }
      }
    }
  }

  void addPredefinedAutomaton() {
    // Clear existing automaton
    reset();

    Node q0 = Node(
        name: 'q0',
        isStart: true,
        isAccepting: false,
        position: const Offset(300, 300));
    Node q1 = Node(
        name: 'q1',
        isStart: false,
        isAccepting: false,
        position: const Offset(500, 300));
    Node q2 = Node(
        name: 'q2',
        isStart: false,
        isAccepting: true,
        position: const Offset(700, 300));

    nodes.addAll([q0, q1, q2]);

    // Add transitions
    Transition t0to1 = Transition(from: q0, to: q1);
    t0to1.setOperations([
      Operations(
          inputTopSymbol: 'ε', stackPopSymbol: 'ε', stackPushSymbol: '\$')
    ]);

    Transition t1to1a = Transition(from: q1, to: q1);
    t1to1a.setOperations([
      Operations(
          inputTopSymbol: 'a', stackPopSymbol: '\$', stackPushSymbol: '\$A'),
      Operations(
          inputTopSymbol: 'a', stackPopSymbol: 'A', stackPushSymbol: 'AA'),
      Operations(
          inputTopSymbol: 'a', stackPopSymbol: 'B', stackPushSymbol: 'ε'),
      Operations(
          inputTopSymbol: 'b', stackPopSymbol: 'B', stackPushSymbol: 'BB'),
      Operations(
          inputTopSymbol: 'b', stackPopSymbol: '\$', stackPushSymbol: '\$B'),
      Operations(
          inputTopSymbol: 'b', stackPopSymbol: 'A', stackPushSymbol: 'ε'),
    ]);

    Transition t1to2 = Transition(from: q1, to: q2);
    t1to2.setOperations([
      Operations(
          inputTopSymbol: 'ε', stackPopSymbol: '\$', stackPushSymbol: 'ε'),
    ]);

    transitions.addAll([t0to1, t1to1a, t1to2]);

    // Set alphabet
    alphabet = 'ab';

    notifyListeners();
  }
}
