import 'package:flutter/foundation.dart';

class PDAStack extends ChangeNotifier {
  List<String> _stack = [];

  List<String> get stack => List.unmodifiable(_stack);

  void push(String item) {
    _stack.add(item);
    notifyListeners();
  }

  String? pop() {
    if (_stack.isNotEmpty) {
      final item = _stack.removeLast();
      notifyListeners();
      return item;
    }
    return null;
  }

  String? peek() {
    if (_stack.isNotEmpty) {
      return _stack.last;
    }
    return null;
  }

  void reset() {
    _stack.clear();
    notifyListeners();
  }
}
