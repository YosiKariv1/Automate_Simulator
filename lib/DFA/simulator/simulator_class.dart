import 'package:flutter/foundation.dart';
import 'package:myapp/classes/dfa_class.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/transition_class.dart';
import 'package:myapp/DFA/simulator/dfa_algorithm.dart';

class Simulator extends ValueNotifier<bool> {
  final DFA automaton;
  DfaAlgorithm algorithm = DfaAlgorithm();
  List<SimulationStep> steps = [];
  int currentStepIndex = -1;
  List<String> processedSymbols = [];
  Set<Transition> highlightedTransitions = {};
  Set<Node> highlightedNodes = {};
  Node? currentNode;
  Transition? currentTransition;
  String? currentSymbol;
  SimulationStepType? lastStepType;
  double speed = 1.0;
  bool isOnNode = true;
  int lastProcessedIndex = -1;
  Set<Transition> permanentHighlightedTransitions = {};
  Set<Node> permanentHighlightedNodes = {};
  Transition? activeTransition;
  bool isPaused = false;
  bool algorithmFinished = false;

  Simulator(this.automaton) : super(false);

  bool get isSimulating => value;

  double get progress {
    if (steps.isEmpty) return 0;
    return (currentStepIndex + 1) / steps.length;
  }

  bool get isPlaying => value && !isPaused;

  void play() {
    if (!value || isPaused) {
      value = true;
      isPaused = false;
      if (steps.isEmpty) {
        _initializeSimulation();
      }
      if (!algorithmFinished) {
        _runSimulation();
      }
    }
    notifyListeners();
  }

  void pause() {
    if (value && !isPaused) {
      isPaused = true;
      notifyListeners();
    }
  }

  void stop() {
    value = false;
    isPaused = false;
    algorithmFinished = false;
    _resetSimulation();
    _resetSimulationState();
    notifyListeners();
  }

  void reset() {
    stop();
    _initializeSimulation();
    play();
    notifyListeners();
  }

  void setSpeed(double newSpeed) {
    speed = newSpeed;
    notifyListeners();
  }

  void setProgress(double progress) {
    if (steps.isEmpty) return;
    int targetIndex = (progress * steps.length).round() - 1;
    _jumpToStep(targetIndex);
  }

  void _initializeSimulation() {
    String input = automaton.word;
    steps = algorithm.simulate(automaton, input);
    currentStepIndex = -1;
    processedSymbols.clear();
    lastProcessedIndex = -1;
    permanentHighlightedTransitions.clear();
    permanentHighlightedNodes.clear();
    activeTransition = null;
    algorithmFinished = false;
  }

  Future<void> _runSimulation() async {
    while (isSimulating && currentStepIndex < steps.length - 1 && !isPaused) {
      await _processNextStep();
      await Future.delayed(Duration(milliseconds: (500 / speed).round()));
    }
    if (currentStepIndex == steps.length - 1) {
      algorithmFinished = true;
      _finalizeSimulation();
    }
    notifyListeners();
  }

  Future<void> _processNextStep() async {
    currentStepIndex++;
    _updateSimulationState(steps[currentStepIndex]);
    notifyListeners();
  }

  void _jumpToStep(int targetIndex) {
    if (targetIndex < -1 || targetIndex >= steps.length) return;

    _resetSimulationState();
    for (int i = 0; i <= targetIndex; i++) {
      _updateSimulationState(steps[i]);
    }
    currentStepIndex = targetIndex;
    notifyListeners();
  }

  void _updateSimulationState(SimulationStep step) {
    currentNode = step.node;
    currentTransition = step.transition;
    currentSymbol = step.symbol;
    lastStepType = step.type;
    isOnNode = (step.transition == null);

    highlightedNodes.add(step.node);
    permanentHighlightedNodes.add(step.node);

    if (step.transition != null) {
      activeTransition = step.transition;
      highlightedTransitions.add(step.transition!);
      permanentHighlightedTransitions.add(step.transition!);
      if (step.symbol != null) {
        processedSymbols.add(step.symbol!);
        lastProcessedIndex =
            automaton.word.indexOf(step.symbol!, lastProcessedIndex + 1);
      }
    } else {
      activeTransition = null;
    }

    _highlightCurrentElements();
  }

  void _resetSimulation() {
    currentStepIndex = -1;
    steps.clear();
    _resetSimulationState();
  }

  void _resetSimulationState() {
    currentNode = null;
    currentTransition = null;
    currentSymbol = null;
    isOnNode = true;
    processedSymbols.clear();
    lastStepType = null;
    lastProcessedIndex = -1;
    highlightedTransitions.clear();
    highlightedNodes.clear();
    permanentHighlightedTransitions.clear();
    permanentHighlightedNodes.clear();
    activeTransition = null;
    _clearAllHighlights();
  }

  void _highlightCurrentElements() {
    for (var node in automaton.nodes) {
      node.isInSimulation = highlightedNodes.contains(node);
      node.isPermanentHighlighted = permanentHighlightedNodes.contains(node);
    }

    for (var transition in automaton.transitions) {
      if (transition == activeTransition) {
        transition.isInSimulation = true;
        transition.isPermanentHighlighted = false;
      } else if (permanentHighlightedTransitions.contains(transition)) {
        transition.isInSimulation = false;
        transition.isPermanentHighlighted = true;
      } else {
        transition.isInSimulation = false;
        transition.isPermanentHighlighted = false;
      }
    }
  }

  void _clearAllHighlights() {
    for (var node in automaton.nodes) {
      node.isInSimulation = false;
      node.isPermanentHighlighted = false;
    }
    for (var transition in automaton.transitions) {
      transition.isInSimulation = false;
      transition.isPermanentHighlighted = false;
    }
  }

  void _finalizeSimulation() {
    for (var node in permanentHighlightedNodes) {
      node.isPermanentHighlighted = true;
    }
    for (var transition in permanentHighlightedTransitions) {
      transition.isPermanentHighlighted = true;
    }
  }
}

enum SimulationStepType {
  start,
  transition,
  intermediate,
  intermediateAccept,
  error,
  accept,
  reject
}

class SimulationStep {
  final Node node;
  final Transition? transition;
  final String? symbol;
  final SimulationStepType type;

  SimulationStep(this.node, this.transition, this.symbol, this.type);
}
