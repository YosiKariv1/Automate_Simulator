import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/TM/simulator/tm_algorithm.dart';
import 'package:myapp/TM/simulator/tm_simulator.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/turing_machine_class.dart';

class TuringSimulator extends ChangeNotifier {
  final TuringMachine turingMachine;
  late final TuringAlgorithm algorithm;
  List<TuringSimulationStep> steps = [];
  List<String>? localTape;
  int currentStepIndex = 0;
  bool run = false;

  TuringSimulator(this.turingMachine) {
    algorithm = TuringAlgorithm(turingMachine: turingMachine);
  }

  void runAlgorithem() {
    localTape = List.from(turingMachine.cells.map((cell) => cell.content));
    steps = algorithm.simulate();
    run = true;
    while (run) {
      currectStep(steps[currentStepIndex]);
    }
  }

  void currectStep(TuringSimulationStep step) {
    highlightNode(step.node);
    readCell();
    highlightTransition();
    writeCell();
    moveHead();
  }

  void highlightNode(Node node) {
    node.isInSimulation = true;
  }

  void readCell() {}

  void highlightTransition() {}

  void writeCell() {}

  void moveHead() {}
}

// class TuringSimulationStep {
//   final int headPosition;
//   final Node node;
//   final Transition transition;
//   final String cellContent;

//   TuringSimulationStep({
//     required this.headPosition,
//     required this.node,
//     required this.transition,
//     required this.cellContent,
//   });
// }
