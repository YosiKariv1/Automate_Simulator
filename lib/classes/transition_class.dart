import 'package:flutter/material.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/rule_class.dart';

class Transition extends ChangeNotifier {
  Node from;
  Node to;
  Set<String> symbol;
  Offset midPoint;
  bool _isInSimulation = false;
  bool isPermanentHighlighted = false;
  bool isError = false;
  bool _isPending = false;

  //For turing machine
  String read = '';
  String write = '';
  String direction = 'Right';

  //For PDA
  String stackPeakSymbol = '';
  String stackTopSymbol = '';
  String stackPushSymbol = '';

  Transition({
    required this.from,
    required this.to,
    required this.symbol,
    this.read = '',
    this.write = '',
    this.direction = 'Right',
  }) : midPoint = Offset.zero {
    from.addListener(onNodeChanged);
    to.addListener(onNodeChanged);
    calculateMidPoint();
  }

  bool get isInSimulation => _isInSimulation;

  Offset get fromPosition => from.rightSideNodeCenter;

  Offset get toPosition => to.leftSideNodeCenter;

  bool get isPending => _isPending;

  set isInSimulation(bool value) {
    _isInSimulation = value;
    notifyListeners();
  }

  set isPending(bool value) {
    _isPending = value;
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

  void onNodeChanged() {
    calculateMidPoint();
    notifyListeners();
  }

  void calculateMidPoint() {
    if (from == to) {
      double midx = (fromPosition.dx + toPosition.dx) / 2 + 2;
      double midy = fromPosition.dy - 70;
      midPoint = Offset(midx, midy);
    } else {
      Offset controlPoint = Offset((fromPosition.dx + toPosition.dx) / 2,
          (fromPosition.dy + toPosition.dy) / 2);
      if (fromPosition.dx > toPosition.dx && fromPosition.dy < toPosition.dy) {
        midPoint = Offset(controlPoint.dx, controlPoint.dy - 100);
      } else if (fromPosition.dx > toPosition.dx &&
          fromPosition.dy > toPosition.dy) {
        midPoint = Offset(controlPoint.dx, controlPoint.dy + 100);
      } else {
        midPoint = controlPoint;
      }
    }
  }

  RRect get textRRect {
    final rect = Rect.fromCenter(center: midPoint, width: 40, height: 24);
    return RRect.fromRectAndRadius(rect, const Radius.circular(8));
  }

  void updateSymbols(Set<String> newSymbols) {
    symbol = newSymbols;
    notifyListeners();
  }

  void setError(bool value) {
    isError = value;
    notifyListeners();
  }

  bool checkRule(Rule rule) {
    return rule.read == read &&
        rule.write == write &&
        rule.direction == direction;
  }
}
