import 'package:flutter/foundation.dart';
import 'package:automaton_simulator/classes/pda_class.dart';
import 'package:automaton_simulator/classes/node_class.dart';
import 'package:automaton_simulator/classes/operations_class.dart';
import 'package:automaton_simulator/classes/transition_class.dart';

class PDASimulator extends ChangeNotifier {
  final PDA pda;
  Node? currentNode;
  String? currentSymbol;
  int inputIndex = 0;
  bool algorithmFinished = false;
  bool isSimulationStarted = false;

  PDASimulator(this.pda);

  void startSimulation() {
    resetSimulation();
    isSimulationStarted = true;
    _runSimulation();
  }

  void stopSimulation() {
    isSimulationStarted = false;
    algorithmFinished = true;
    _clearHighlights();
    pda.pdaStack.reset();
    notifyListeners();
  }

  void resetSimulation() {
    _initializeSimulation();
    notifyListeners();
  }

  void _initializeSimulation() {
    pda.pdaStack.reset();
    pda.pushToStack('\$');

    currentNode = pda.nodes
        .firstWhere((node) => node.isStart, orElse: () => pda.nodes.first);
    currentSymbol = pda.word.isNotEmpty ? pda.word[0] : 'ε';
    inputIndex = 0;
    algorithmFinished = false;
    isSimulationStarted = false;

    _clearHighlights();

    print(
        "Simulation initialized. Start state: ${currentNode?.name}, Word: ${pda.word}");
  }

  void _clearHighlights() {
    for (var node in pda.nodes) {
      node.isInSimulation = false;
      node.isPermanentHighlighted = false;
    }
    for (var transition in pda.transitions) {
      transition.isInSimulation = false;
      transition.isPermanentHighlighted = false;
      for (var operation in transition.operations) {
        operation.isCorrect = false; // נוסיף את איפוס ההדגשה לפעולות
      }
    }
  }

  Future<void> _runSimulation() async {
    while (!algorithmFinished && isSimulationStarted) {
      await _processStep();
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> _processStep() async {
    if (algorithmFinished || !isSimulationStarted) return;

    print("\nCurrent state: ${currentNode?.name}");
    print("Current input symbol: $currentSymbol");
    print("Current stack: ${pda.pdaStack.stack}");

    _highlightNode(currentNode);
    await Future.delayed(Duration(milliseconds: 300));
    notifyListeners();

    bool moved = await _tryTransitions();

    if (!moved) {
      if (currentNode?.isAccepting == true && inputIndex == pda.word.length) {
        print("Accepted: Reached an accepting state");
        algorithmFinished = true;
      } else if (inputIndex == pda.word.length &&
          (pda.pdaStack.stack.isEmpty ||
              (pda.pdaStack.stack.length == 1 &&
                  pda.pdaStack.stack.first == '\$'))) {
        print("Accepted: Empty stack (except for \$)");
        algorithmFinished = true;
      } else {
        print("Rejected: No valid transition or conditions not met");
        algorithmFinished = true;
      }
    }
    notifyListeners();
  }

  Future<bool> _tryTransitions() async {
    for (var transition
        in pda.transitions.where((t) => t.from == currentNode)) {
      bool transitionApplied = false;
      for (var operation in transition.operations) {
        if (_checkOperation(operation, currentSymbol, pda.pdaStack.stack)) {
          print(
              "Transition found: ${transition.toString()} with operation: ${operation.toString()}"); // Debugging line
          _highlightTransition(transition);
          _highlightOperation(operation);
          await Future.delayed(Duration(milliseconds: 300));
          notifyListeners();

          _applyOperation(operation);

          if (operation.inputTopSymbol != 'ε') {
            inputIndex++;
            currentSymbol =
                inputIndex < pda.word.length ? pda.word[inputIndex] : 'ε';
          }

          await Future.delayed(Duration(milliseconds: 300));
          notifyListeners();

          currentNode = transition.to;
          _highlightNode(currentNode);
          transitionApplied = true;
          return true;
        }
      }
    }
    return false;
  }

  void _applyOperation(Operations operation) {
    print("Applying operation: ${operation.toString()}");
    print("Stack before: ${pda.pdaStack.stack}");

    // Handle pop operation
    if (operation.stackPopSymbol != 'ε') {
      if (pda.pdaStack.stack.isNotEmpty &&
          (pda.pdaStack.stack.last == operation.stackPopSymbol ||
              operation.stackPopSymbol == '\$')) {
        String? popped = pda.popFromStack();
        print("Popped from stack: $popped");
        _highlightOperation(operation); // Highlight after applying
      } else {
        print(
            "Warning: Cannot pop ${operation.stackPopSymbol}, top of stack is ${pda.pdaStack.stack.isNotEmpty ? pda.pdaStack.stack.last : 'empty'}");
        return;
      }
    }

    // Handle push operation
    if (operation.stackPushSymbol != 'ε') {
      List<String> symbolsToPush = operation.stackPushSymbol.split('');
      for (var symbol in symbolsToPush) {
        if (symbol == '\$') {
          if (!pda.pdaStack.stack.contains('\$')) {
            pda.pushToStack('\$');
            print("Inserted \$ at the bottom of the stack");
          }
        } else {
          pda.pushToStack(symbol);
          print("Pushed to stack: $symbol");
        }
      }
      _highlightOperation(operation); // Highlight after applying
    }

    print("Stack after: ${pda.pdaStack.stack}");
  }

  void _highlightNode(Node? node) {
    if (node != null) {
      node.isInSimulation = false;
      node.isPermanentHighlighted = true;
    }
  }

  void _highlightTransition(Transition transition) {
    transition.isInSimulation = false;
    transition.isPermanentHighlighted = true;
  }

  void _highlightOperation(Operations operation) {
    operation.isCorrect = true; // הדגשת הפעולה הנכונה בצבע ירוק
  }

  bool _checkOperation(
      Operations operation, String? inputSymbol, List<String> stack) {
    bool inputMatch = operation.inputTopSymbol == inputSymbol ||
        operation.inputTopSymbol == 'ε';
    bool stackMatch = operation.stackPopSymbol == 'ε' ||
        (stack.isNotEmpty && operation.stackPopSymbol == stack.last);

    return inputMatch && stackMatch;
  }
}
