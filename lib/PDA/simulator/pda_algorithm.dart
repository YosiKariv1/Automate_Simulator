// import 'package:myapp/classes/pda_class.dart';
// import 'package:myapp/classes/node_class.dart';
// import 'package:myapp/classes/transition_class.dart';
// import 'package:myapp/classes/operations_class.dart';
// import 'package:myapp/PDA/simulator/pda_simulator.dart';

// class NodeWithTransitions {
//   final Node node;
//   final List<Transition> outgoingTransitions;

//   NodeWithTransitions(this.node, this.outgoingTransitions);
// }

// class PDAAlgorithm {
//   List<SimulationStep> steps = [];
//   List<NodeWithTransitions> structure = [];
//   List<String> stack = [];

//   List<NodeWithTransitions> buildDataStructure(PDA pda) {
//     List<NodeWithTransitions> structure = [];

//     for (var node in pda.nodes) {
//       List<Transition> outgoing =
//           pda.transitions.where((t) => t.from == node).toList();

//       structure.add(NodeWithTransitions(node, outgoing));
//     }

//     return structure;
//   }

//   void initializeAlgorithm() {
//     steps = [];
//     stack = [];
//   }

//   List<SimulationStep> computeSteps(PDA pda) {
//     initializeAlgorithm();
//     structure = buildDataStructure(pda);

//     if (structure.isEmpty) {
//       print("PDA is empty");
//       return steps;
//     }

//     NodeWithTransitions current = structure
//         .firstWhere((nwt) => nwt.node.isStart, orElse: () => structure[0]);

//     print("Starting simulation with word: ${pda.word}");
//     print("Initial state: ${current.node.name}");

//     steps.add(SimulationStep(
//       type: SimulationStepType.move,
//       currentNode: current.node,
//     ));

//     int inputIndex = 0;
//     while (inputIndex <= pda.word.length) {
//       String inputSymbol =
//           inputIndex < pda.word.length ? pda.word[inputIndex] : 'ε';

//       print("\nCurrent state: ${current.node.name}");
//       print("Current input symbol: $inputSymbol");
//       print("Current stack: $stack");

//       bool moved = false;

//       // Try non-epsilon transitions first
//       moved = tryAllTransitions(current, inputSymbol, stack, pda, steps, false);

//       // If no move with input symbol, try epsilon transitions
//       if (!moved) {
//         moved = tryAllTransitions(current, 'ε', stack, pda, steps, true);
//       }

//       if (!moved) {
//         if (inputIndex == pda.word.length &&
//             current.node.isAccepting &&
//             (stack.isEmpty || (stack.length == 1 && stack.first == '\$'))) {
//           steps.add(SimulationStep(
//             type: SimulationStepType.accept,
//             currentNode: current.node,
//           ));
//           print("Accepted: Final state and empty stack (except for \$)");
//         } else {
//           steps.add(SimulationStep(
//             type: SimulationStepType.reject,
//             currentNode: current.node,
//           ));
//           print("Rejected: No valid transition or non-empty stack");
//         }
//         break;
//       }

//       current =
//           structure.firstWhere((nwt) => nwt.node == steps.last.currentNode);

//       // Advance input index only if a non-epsilon transition was made
//       if (!steps.last.isInputTopSymbolEpsilon && inputSymbol != 'ε') {
//         inputIndex++;
//       }
//     }

//     return steps;
//   }

//   bool tryAllTransitions(
//     NodeWithTransitions current,
//     String inputSymbol,
//     List<String> stack,
//     PDA pda,
//     List<SimulationStep> steps,
//     bool allowEpsilon,
//   ) {
//     for (var transition in current.outgoingTransitions) {
//       for (var operation in transition.operations) {
//         bool isEpsilonTransition = operation.inputTopSymbol == 'ε';
//         if ((allowEpsilon && isEpsilonTransition) ||
//             (!allowEpsilon && !isEpsilonTransition)) {
//           if (_checkOperation(operation, inputSymbol, stack)) {
//             print("Applying operation: ${operation.toString()}");
//             _applyOperation(operation, stack);
//             steps.add(SimulationStep(
//               type: SimulationStepType.move,
//               currentNode: transition.to,
//               transition: transition,
//               inputSymbol: inputSymbol,
//               stackOperation: StackOperation(
//                 pop: operation.stackPopSymbol,
//                 push: operation.stackPushSymbol,
//               ),
//               isInputTopSymbolEpsilon: isEpsilonTransition,
//               isStackPopSymbolEpsilon: operation.stackPopSymbol == 'ε',
//               isStackPushSymbolEpsilon: operation.stackPushSymbol == 'ε',
//             ));
//             return true;
//           }
//         }
//       }
//     }
//     return false;
//   }

//   void _applyOperation(Operations operation, List<String> stack) {
//     // Pop operation
//     if (operation.stackPopSymbol != 'ε' && stack.isNotEmpty) {
//       if (stack.last == operation.stackPopSymbol) {
//         String popped = stack.removeLast();
//         print("Popped from stack: $popped");
//       } else {
//         print(
//             "Warning: Tried to pop ${operation.stackPopSymbol}, but top of stack is ${stack.last}");
//         return;
//       }
//     }

//     // Push operation
//     if (operation.stackPushSymbol != 'ε') {
//       List<String> symbolsToPush = operation.stackPushSymbol.split('');

//       // If `$` should be at the bottom, insert it first if not present
//       if (!stack.contains('\$')) {
//         stack.insert(0, '\$');
//         print("Inserted \$ at the bottom of the stack");
//       }

//       // Push remaining symbols on top
//       for (var symbol in symbolsToPush.reversed) {
//         if (symbol != '\$') {
//           stack.add(symbol);
//           print("Pushed to stack: $symbol");
//         }
//       }
//     }
//   }

//   bool _checkOperation(
//       Operations operation, String inputSymbol, List<String> stack) {
//     bool inputMatch = operation.inputTopSymbol == inputSymbol ||
//         operation.inputTopSymbol == 'ε';

//     bool stackMatch = operation.stackPopSymbol == 'ε' ||
//         (stack.isNotEmpty && operation.stackPopSymbol == stack.last) ||
//         (operation.stackPopSymbol == '\$' &&
//             stack.isNotEmpty &&
//             stack.first == '\$');

//     return inputMatch && stackMatch;
//   }
// }
