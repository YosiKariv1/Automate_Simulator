import 'package:automaton_simulator/TM/simulator/tm_simulator.dart';
import 'package:automaton_simulator/classes/node_class.dart';
import 'package:automaton_simulator/classes/transition_class.dart';
import 'package:automaton_simulator/classes/turing_machine_class.dart';

class TuringAlgorithm {
  final TuringMachine turingMachine;
  List<TuringSimulationStep> steps = [];
  int currentPosition = 0;
  Node? currentNode;
  Transition? transition;
  List<String>? localTape;

  TuringAlgorithm({required this.turingMachine});

  List<TuringSimulationStep> simulate() {
    currentPosition = turingMachine.headPosition;
    currentNode = turingMachine.nodes.firstWhere((node) => node.isStart,
        orElse: () => turingMachine.nodes.first);
    localTape = List.from(turingMachine.cells.map((cell) => cell.content));

    while (true) {
      // Find a valid transition
      final validTransitions = turingMachine.transitions
          .where((trans) =>
              trans.from == currentNode &&
              trans.read == localTape![currentPosition])
          .toList();

      // No valid transitions found
      if (validTransitions.isEmpty) {
        print(
            "No valid transition found for symbol '${localTape![currentPosition]}' in state '${currentNode!.name}'. Simulation halted.");
        currentNode!.setError(true); // Highlight the node as an error
        break;
      }

      transition = validTransitions.first;

      // Add the step to the simulation
      steps.add(TuringSimulationStep(
          headPosition: currentPosition,
          node: currentNode!,
          transition: transition!,
          cellContentWrite: transition!.write,
          cellContentRead: transition!.read));

      // Update the tape and move the head
      localTape![currentPosition] = transition!.write;
      currentPosition +=
          (transition!.direction.toLowerCase() == 'right') ? 1 : -1;

      // Check if the head goes out of tape bounds
      if (currentPosition < 0 || currentPosition >= localTape!.length) {
        print("Head moved out of tape bounds at position $currentPosition");
        break;
      }

      // Update the current state
      currentNode = transition!.to;
    }

    return steps;
  }
}
