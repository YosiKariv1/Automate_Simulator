import 'package:myapp/PDA/simulator/pda_simulator.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/operations_class.dart';
import 'package:myapp/classes/pda_class.dart';
import 'package:myapp/classes/transition_class.dart';

class PDAAlgorithm {
  List<SimulationStep> computeSteps(PDA pda) {
    List<SimulationStep> steps = [];
    print("Starting!");

    // Check if there are any nodes in the PDA
    if (pda.nodes.isEmpty) {
      print("Error: No nodes defined in the PDA.");
      return steps; // Return empty steps if no nodes are available
    }

    // Set the current node to the start node, if defined
    Node? currentNode = pda.nodes.first;

    int inputIndex = 0;
    List<String> stack = []; // Initialize the stack as empty

    steps.add(SimulationStep(
      type: SimulationStepType.move,
      currentNode: currentNode,
    ));

    while (inputIndex < pda.word.length || stack.isNotEmpty) {
      bool moved = false;
      print(
          "Current Node: ${currentNode!.name}, Stack: $stack, Input Index: $inputIndex");

      for (Transition transition
          in pda.transitions.where((t) => t.from == currentNode)) {
        for (var operation in transition.operations) {
          print(
              'Checking transition from ${transition.from.name} to ${transition.to.name} with operation: $operation');

          if (_checkOperation(operation, inputIndex, stack, pda)) {
            print('Operation matched: $operation');
            _applyOperation(operation, inputIndex, stack);
            steps.add(SimulationStep(
              type: SimulationStepType.move,
              currentNode: transition.to,
              transition: transition,
              inputSymbol:
                  inputIndex < pda.word.length ? pda.word[inputIndex] : null,
              stackSymbol: stack.isNotEmpty ? stack.last : null,
            ));
            currentNode = transition.to;
            if (operation.inputTopSymbol != 'ε') inputIndex++;
            moved = true;
            break;
          }
        }
        if (moved) break;
      }

      if (!moved) {
        print('No valid move found, adding error step.');
        steps.add(SimulationStep(type: SimulationStepType.error));
        return steps;
      }

      if (inputIndex == pda.word.length && stack.isEmpty) {
        steps.add(SimulationStep(
          type: currentNode!.isAccepting
              ? SimulationStepType.accept
              : SimulationStepType.reject,
          currentNode: currentNode,
        ));
        return steps;
      }
    }

    steps.add(SimulationStep(
        type: SimulationStepType.reject, currentNode: currentNode));
    return steps;
  }

  bool _checkOperation(
      Operations operation, int inputIndex, List<String> stack, PDA pda) {
    // בדיקת התאמת קלט
    bool inputMatch = operation.inputTopSymbol == 'ε' ||
        (inputIndex < pda.word.length &&
            operation.inputTopSymbol == pda.word[inputIndex]);

    // בדיקת התאמת מחסנית
    bool stackMatch = (operation.stackPeakSymbol == 'ε') ||
        (stack.isNotEmpty && operation.stackPeakSymbol == stack.last) ||
        (stack.isEmpty && operation.stackPeakSymbol == '');

    // הוספת דיבוג להבנת חוסר התאמה
    if (!inputMatch) {
      print(
          "Input does not match: Expected '${operation.inputTopSymbol}', Found '${inputIndex < pda.word.length ? pda.word[inputIndex] : 'End of Input'}'");
    }
    if (!stackMatch) {
      print(
          "Stack does not match: Expected '${operation.stackPeakSymbol}', Found '${stack.isNotEmpty ? stack.last : 'Empty Stack'}'");
    }

    return inputMatch && stackMatch;
  }

  void _applyOperation(
      Operations operation, int inputIndex, List<String> stack) {
    if (operation.stackPopSymbol != 'ε' && stack.isNotEmpty) {
      stack.removeLast();
    }
    if (operation.stackPushSymbol != 'ε') {
      stack.add(operation.stackPushSymbol);
    }
  }
}
