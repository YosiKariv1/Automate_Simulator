import 'package:flutter/material.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/operations_class.dart';
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
  List<Operations> operations;

  // Dynamic dimensions
  double operationHeight = 20.0;
  double baseHeight = 24.0;
  double operationWidth = 20.0;
  double baseWidth = 50.0;

  Transition({
    required this.from,
    required this.to,
    this.symbol = const {},
    this.read = '',
    this.write = '',
    this.direction = 'Right',
    this.operations = const [],
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
      Offset controlPoint = Offset(
        (fromPosition.dx + toPosition.dx) / 2,
        (fromPosition.dy + toPosition.dy) / 2,
      );

      // עדכון נקודת האמצע אם הקונטיינר גבוה מדי
      double dynamicHeight = baseHeight + (operations.length * operationHeight);
      if (dynamicHeight > from.nodeSize) {
        controlPoint = Offset(
          controlPoint.dx,
          controlPoint.dy - dynamicHeight / 2 + from.nodeSize / 2,
        );
      }

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
    double calculatedHeight = baseHeight;
    double calculatedWidth = baseWidth;

    if (operations.isNotEmpty) {
      // אם יש יותר מ-1 פעולות, הגדל את הגובה
      if (operations.length > 1) {
        calculatedHeight = baseHeight + (operations.length * operationHeight);
        calculatedWidth = baseWidth + (operations.length * operationWidth);
      }

      if (operations.length < 2) {
        calculatedWidth += 25;
        calculatedHeight += 10;
      }

      if (operations.length > 2) {
        calculatedHeight = calculatedHeight + (operations.length * 6);
      }

      double midx = midPoint.dx;
      double midy = midPoint.dy;

      // אם יש לולאה ויש יותר מ-2 פעולות, העלה את המיקום של ה-RRect בציר ה-Y בצורה מבוקרת
      if (from == to && operations.length > 2) {
        midy -= from.nodeSize / 2 +
            (operations.length - 2) * 10; // העלה בהתאם לכמות הפעולות
      }

      final rect = Rect.fromCenter(
          center: Offset(midx, midy),
          width: calculatedWidth,
          height: calculatedHeight);
      return RRect.fromRectAndRadius(rect, const Radius.circular(8));
    } else {
      // אם אין פעולות, השתמש בגובה ורוחב הבסיס
      final rect = Rect.fromCenter(
          center: midPoint, width: baseWidth, height: baseHeight);
      return RRect.fromRectAndRadius(rect, const Radius.circular(8));
    }
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

  void addOperation(Operations operation) {
    operations.add(operation);
    notifyListeners();
  }

  void removeOperation(Operations operation) {
    operations.remove(operation);
    notifyListeners();
  }

  void setOperations(List<Operations> newOperations) {
    operations = newOperations;
    notifyListeners();
  }
}
