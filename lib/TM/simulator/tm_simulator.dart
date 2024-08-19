import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:myapp/TM/simulator/tm_algorithm.dart';
import 'package:myapp/classes/turing_machine_class.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/transmition_class.dart';

class TuringSimulator extends ValueNotifier<bool> {
  final TuringMachine turingMachine;
  final TuringAlgorithm algorithm;
  List<TuringSimulationStep> steps = [];
  int currentStepIndex = -1;
  bool isPaused = true;
  double speed = 1.0;
  bool algorithmFinished = false;
  List<String> initialTapeState = [];
  int initialHeadPosition = 0;

  TuringSimulator(this.turingMachine)
      : algorithm = TuringAlgorithm(turingMachine: turingMachine),
        super(false);

  bool get isPlaying => value && !isPaused;

  void playPause() {
    if (!value || isPaused) {
      isPaused = false;
      value = true;
      if (steps.isEmpty) {
        _backupInitialState();
        _generateSteps();
      }
      if (!algorithmFinished) {
        _runSimulation();
      }
    } else {
      pause();
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
    _restoreInitialState();
    _resetHighlights();
    notifyListeners();
  }

  void reset() {
    stop();
    playPause();
    notifyListeners();
  }

  void setSpeed(double newSpeed) {
    speed = newSpeed;
    notifyListeners();
  }

  void setProgress(double progress) {
    if (steps.isEmpty) return;
    int targetIndex =
        (progress * steps.length).round().clamp(0, steps.length - 1);
    _jumpToStep(targetIndex);
  }

  void _backupInitialState() {
    initialTapeState = turingMachine.cells.map((cell) => cell.content).toList();
    initialHeadPosition = turingMachine.headPosition;
  }

  void _restoreInitialState() {
    for (int i = 0; i < turingMachine.cells.length; i++) {
      turingMachine.cells[i].content = initialTapeState[i];
    }
    turingMachine.setHeadPosition(initialHeadPosition);
    notifyListeners();
  }

  void _generateSteps() {
    steps = algorithm.simulate();
    currentStepIndex = -1;
    algorithmFinished = false;
    notifyListeners();
  }

  Future<void> _runSimulation() async {
    while (isPlaying && currentStepIndex < steps.length - 1) {
      await _processNextStep();
      await Future.delayed(Duration(milliseconds: (1000 / speed).round()));

      int nextPosition = steps[currentStepIndex].headPosition + 1;
      if (nextPosition < turingMachine.cells.length) {
        String nextCellContent = turingMachine.cells[nextPosition].content;

        // Find valid transitions from the current node for the next cell
        final validNextTransitions = turingMachine.transitions
            .where((trans) =>
                trans.from == steps[currentStepIndex].transition.to &&
                trans.read == nextCellContent)
            .toList();

        if (validNextTransitions.isEmpty) {
          // No valid transition for the next cell's symbol, mark as error
          turingMachine.cells[nextPosition].isError = true;
          print(
              "No valid transition found for symbol '$nextCellContent' in state '${steps[currentStepIndex].transition.to.name}'. Simulation halted.");
          break;
        }
      }
    }
    _moveHeadFinalStep();
    if (currentStepIndex == steps.length - 1) {
      algorithmFinished = true;
    }
    notifyListeners();
  }

  Future<void> _processNextStep() async {
    if (isPaused) return; // Exit if the simulation is paused

    currentStepIndex++;
    await _applyStep(steps[currentStepIndex]);
    notifyListeners();
  }

  void _jumpToStep(int targetIndex) {
    _resetSimulationState();
    for (int i = 0; i <= targetIndex; i++) {
      _applyStep(steps[i]);
    }
    currentStepIndex = targetIndex;
    notifyListeners();
  }

  Future<void> _applyStep(TuringSimulationStep step) async {
    _highlightNode(step.node);
    turingMachine.setHeadPosition(step.headPosition);
    await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
    await _flashTransition(step.transition);
    turingMachine.updateTapeContent(step.headPosition, step.cellContentWrite);
    _highlightTransition(step.transition);
    notifyListeners();
  }

  void _resetSimulation() {
    currentStepIndex = -1;
    steps.clear();
    _resetSimulationState();
  }

  void _resetSimulationState() {
    _resetHighlights();
    notifyListeners();
  }

  void _resetHighlights() {
    for (var node in turingMachine.nodes) {
      node.isInSimulation = false;
      node.isPermanentHighlighted = false;
    }
    for (var transition in turingMachine.transitions) {
      transition.isInSimulation = false;
      transition.isPermanentHighlighted = false;
    }
  }

  void _highlightNode(Node node) {
    node.isInSimulation = true;
    node.isPermanentHighlighted = true;
    notifyListeners();
  }

  void _highlightTransition(Transition transition) {
    transition.isPermanentHighlighted = true;
    notifyListeners();
  }

  Future<void> _flashTransition(Transition transition) async {
    transition.isPermanentHighlighted = false;
    for (int i = 0; i < 3; i++) {
      transition.isPending = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
      transition.isPending = false;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
    }
    transition.isPermanentHighlighted =
        true; // Ensure it's green after flashing
  }

  void _moveHeadFinalStep() {
    if (currentStepIndex >= 0 && currentStepIndex < steps.length) {
      final lastTransition = steps[currentStepIndex].transition;
      final lastDirection = lastTransition.direction.toLowerCase();

      if (lastDirection == 'right') {
        turingMachine.setHeadPosition(turingMachine.headPosition + 1);
      } else if (lastDirection == 'left') {
        turingMachine.setHeadPosition(turingMachine.headPosition - 1);
      }
      notifyListeners();
    }
  }
}

class TuringSimulationStep {
  final int headPosition;
  final Node node;
  final Transition transition;
  final String cellContentWrite;
  final String cellContentRead;

  TuringSimulationStep({
    required this.headPosition,
    required this.node,
    required this.transition,
    required this.cellContentWrite,
    required this.cellContentRead,
  });
}
