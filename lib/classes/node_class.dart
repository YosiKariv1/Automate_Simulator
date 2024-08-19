import 'package:flutter/material.dart';

class Node extends ChangeNotifier {
  String name;
  bool isAccepting;
  bool isStart;
  Offset position;
  double nodeSize = 60;
  double smallCircleSize = 20;
  bool _isInSimulation = false;
  bool isPermanentHighlighted = false;
  bool isError = false;

  Node(
      {required this.name,
      this.isAccepting = false,
      required this.position,
      this.isStart = false});

  bool get isInSimulation => _isInSimulation;
  set isInSimulation(bool value) {
    _isInSimulation = value;
    notifyListeners();
  }

  void setError(bool value) {
    isError = value;
    notifyListeners();

    if (value) {
      Future.delayed(const Duration(seconds: 3), () {
        isError = false;
        notifyListeners();
      });
    }
  }

  void updatePosition(Offset newPosition) {
    position = newPosition;
    notifyListeners();
  }

  void toggleAcceptingState() {
    isAccepting = !isAccepting;
    notifyListeners();
  }

  void startSimulation() {
    _isInSimulation = true;
    notifyListeners();
  }

  void endSimulation() {
    _isInSimulation = false;
    notifyListeners();
  }

  Offset get leftSideNode => Offset(
      position.dx - nodeSize / 2 + smallCircleSize,
      position.dy + nodeSize / 2 - smallCircleSize / 2);

  Offset get rightSideNode => Offset(
      position.dx + nodeSize - smallCircleSize / 2,
      position.dy + nodeSize / 2 - smallCircleSize / 2);

  Offset get leftSideNodeCenter => Offset(leftSideNode.dx + smallCircleSize / 2,
      leftSideNode.dy + smallCircleSize / 2);

  Offset get rightSideNodeCenter => Offset(
      rightSideNode.dx + smallCircleSize / 2,
      rightSideNode.dy + smallCircleSize / 2);

  Offset get nodeCenter =>
      Offset(position.dx + nodeSize / 2, position.dy + nodeSize / 2);
}
