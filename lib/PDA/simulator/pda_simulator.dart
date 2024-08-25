import 'package:flutter/material.dart';
import 'package:myapp/PDA/simulator/pda_algorithm.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/pda_class.dart';
import 'package:myapp/classes/transition_class.dart';

class PDASimulation extends ValueNotifier<bool> {
  final PDA pda;
  List<SimulationStep> steps = [];
  PDAAlgorithm algorithm = PDAAlgorithm();
  int currentStepIndex = -1;
  bool isSimulating = false;
  bool algorithmFinished = false;

  // Local variables for simulation
  Node? currentNode;
  Transition? currentTransition;

  PDASimulation(this.pda) : super(false);

  void start() {
    if (pda.nodes.isEmpty) {
      print(
          "No nodes in PDA. Please add at least one node to start simulation.");
      return; // Do nothing if there are no nodes
    }

    _initializeSimulation(); // Initialize steps before starting simulation

    if (steps.isEmpty) {
      print("No steps available for simulation.");
      return;
    }

    if (currentStepIndex == -1) {
      isSimulating = true;
      algorithmFinished = false;
      notifyListeners();
      _executeNextStep();
    }
  }

  void stop() {
    isSimulating = false;
    notifyListeners();
  }

  void reset() {
    currentStepIndex = -1;
    isSimulating = false;
    algorithmFinished = false;
    pda.reset();

    if (pda.nodes.isNotEmpty) {
      currentNode = pda.nodes.first; // Reset to first node if exists
    } else {
      currentNode = null; // No nodes to reset
    }

    currentTransition = null; // Reset transition
    _resetAllNodesAndTransitions();
    notifyListeners();
  }

  void _executeNextStep() {
    if (!isSimulating || currentStepIndex >= steps.length - 1) {
      algorithmFinished = true;
      isSimulating = false;
      notifyListeners();
      return;
    }

    currentStepIndex++;
    SimulationStep step = steps[currentStepIndex];

    switch (step.type) {
      case SimulationStepType.move:
        _setCurrentNode(step.currentNode);
        _highlightTransition(step.transition);
        break;
      case SimulationStepType.push:
      case SimulationStepType.pop:
        // These operations are handled in the PDA class
        break;
      case SimulationStepType.accept:
      case SimulationStepType.reject:
      case SimulationStepType.error:
        algorithmFinished = true;
        isSimulating = false;
        break;
    }

    notifyListeners();

    // Schedule the next step
    Future.delayed(const Duration(milliseconds: 1000), _executeNextStep);
  }

  // Local method to set the current node
  void _setCurrentNode(Node? node) {
    if (currentNode != null) {
      currentNode!.isInSimulation = false; // Reset previous node state
    }
    currentNode = node;
    if (currentNode != null) {
      currentNode!.isInSimulation = true; // Highlight new node
    }
  }

  // Local method to highlight the transition
  void _highlightTransition(Transition? transition) {
    if (currentTransition != null) {
      currentTransition!.isInSimulation =
          false; // Reset previous transition state
    }
    currentTransition = transition;
    if (currentTransition != null) {
      currentTransition!.isInSimulation = true; // Highlight new transition
    }
  }

  // Method to reset all nodes and transitions
  void _resetAllNodesAndTransitions() {
    for (var node in pda.nodes) {
      node.isInSimulation = false;
    }
    for (var transition in pda.transitions) {
      transition.isInSimulation = false;
    }
  }

  // Initialize the simulation steps
  void _initializeSimulation() {
    steps = algorithm.computeSteps(pda);

    if (steps.isEmpty) {
      print("No valid steps were found for the given configuration.");
      currentNode = null;
    } else {
      currentNode = pda.nodes
          .firstWhere((node) => node.isStart, orElse: () => pda.nodes.first);
    }

    currentStepIndex = -1; // Reset step index
    notifyListeners();
  }
}

enum SimulationStepType { move, push, pop, accept, reject, error }

class SimulationStep {
  final SimulationStepType type;
  final Node? currentNode;
  final Transition? transition;
  final String? inputSymbol;
  final String? stackSymbol;

  SimulationStep({
    required this.type,
    this.currentNode,
    this.transition,
    this.inputSymbol,
    this.stackSymbol,
  });
}
