import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/classes/node_class.dart';
import 'package:automaton_simulator/classes/transition_class.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'package:flutter/foundation.dart';

class DfaAlgorithm {
  List<SimulationStep> simulate(DFA automaton, String input) {
    List<SimulationStep> steps = [];

    // Build a map of outgoing transitions for quick access.
    final Map<Node, List<Transition>> transitionsMap = {};
    for (var transition in automaton.transitions) {
      transitionsMap.putIfAbsent(transition.from, () => []).add(transition);
    }

    if (automaton.nodes.isEmpty) {
      if (kDebugMode) {
        print("האוטומט ריק");
      }
      return steps;
    }

    Node current = automaton.nodes
        .firstWhere((n) => n.isStart, orElse: () => automaton.nodes.first);

    // Add an initial step to highlight the start state without processing any input
    steps.add(
        SimulationStep(current, null, null, SimulationStepType.start));

    for (int inputIndex = 0; inputIndex < input.length; inputIndex++) {
      String symbol = input[inputIndex];
      Transition? matchingTransition;

      for (var transition in transitionsMap[current] ?? []) {
        if (transition.symbol.contains(symbol)) {
          matchingTransition = transition;
          break;
        }
      }

      if (matchingTransition == null) {
        // אין מעבר מתאים
        steps.add(
            SimulationStep(current, null, symbol, SimulationStepType.error));
        return steps; // מסיימים את הסימולציה עם שגיאה
      }

      // הדגשת המעבר
      steps.add(SimulationStep(current, matchingTransition, symbol,
          SimulationStepType.transition));

      // מעבר לצומת הבא
      current = matchingTransition.to;

      // בדיקת מצב ביניים
      if (inputIndex < input.length - 1) {
        SimulationStepType intermediateType = current.isAccepting
            ? SimulationStepType.intermediateAccept
            : SimulationStepType.intermediate;
        steps.add(SimulationStep(current, null, null, intermediateType));
      }
    }

    // בדיקת מצב סופי
    if (current.isAccepting) {
      steps.add(SimulationStep(current, null, null, SimulationStepType.accept));
    } else {
      steps.add(SimulationStep(current, null, null, SimulationStepType.reject));
    }

    return steps;
  }
}
