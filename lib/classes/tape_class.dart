import 'package:flutter/material.dart';

class TapeCell extends ChangeNotifier {
  String _content;
  bool _isHead;
  bool _isError; // חדש

  TapeCell({String content = '', bool isHead = false, bool isError = false})
      : _content = content,
        _isHead = isHead,
        _isError = isError;

  // Getters
  String get content => _content;
  bool get isHead => _isHead;
  bool get isError => _isError; // חדש

  // Setters עם notifyListeners
  set content(String value) {
    _content = value;
    notifyListeners();
  }

  set isHead(bool value) {
    _isHead = value;
    notifyListeners();
  }

  set isError(bool value) {
    _isError = value;
    notifyListeners();
  }

  void write(String value) {
    content = value;
  }

  void clear() {
    content = '';
  }
}
