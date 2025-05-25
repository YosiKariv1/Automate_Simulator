import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/classes/node_class.dart';
import 'package:automaton_simulator/classes/transition_class.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'package:flutter/foundation.dart';

class NodeWithTransitions {
  final Node node;
  final List<Transition> outgoingTransitions;

  NodeWithTransitions(this.node, this.outgoingTransitions);
}

class DfaAlgorithm {
  List<NodeWithTransitions> buildDataStructure(DFA automaton) {
    List<NodeWithTransitions> structure = [];

    for (var node in automaton.nodes) {
      List<Transition> outgoing =
          automaton.transitions.where((t) => t.from == node).toList();

      structure.add(NodeWithTransitions(node, outgoing));
    }

    return structure;
  }

  List<SimulationStep> simulate(DFA automaton, String input) {
    List<SimulationStep> steps = [];
    List<NodeWithTransitions> structure = buildDataStructure(automaton);

    if (structure.isEmpty) {
      if (kDebugMode) {
        print("האוטומט ריק");
      }
      return steps;
    }

    NodeWithTransitions current = structure[0]; // מצב התחלתי

    // Add an initial step to highlight the start state without processing any input
    steps.add(
        SimulationStep(current.node, null, null, SimulationStepType.start));

    for (int inputIndex = 0; inputIndex < input.length; inputIndex++) {
      String symbol = input[inputIndex];
      Transition? matchingTransition;

      for (var transition in current.outgoingTransitions) {
        if (transition.symbol.contains(symbol)) {
          matchingTransition = transition;
          break;
        }
      }

      if (matchingTransition == null) {
        // אין מעבר מתאים
        steps.add(SimulationStep(
            current.node, null, symbol, SimulationStepType.error));
        return steps; // מסיימים את הסימולציה עם שגיאה
      }

      // הדגשת המעבר
      steps.add(SimulationStep(current.node, matchingTransition, symbol,
          SimulationStepType.transition));

      // מעבר לצומת הבא
      current =
          structure.firstWhere((nwt) => nwt.node == matchingTransition!.to);

      // בדיקת מצב ביניים
      if (inputIndex < input.length - 1) {
        SimulationStepType intermediateType = current.node.isAccepting
            ? SimulationStepType.intermediateAccept
            : SimulationStepType.intermediate;
        steps.add(SimulationStep(current.node, null, null, intermediateType));
      }
    }

    // בדיקת מצב סופי
    if (current.node.isAccepting) {
      steps.add(
          SimulationStep(current.node, null, null, SimulationStepType.accept));
    } else {
      steps.add(
          SimulationStep(current.node, null, null, SimulationStepType.reject));
    }

    return steps;
  }
}
