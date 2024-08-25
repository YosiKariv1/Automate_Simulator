class Operations {
  String stackPeakSymbol;
  String inputTopSymbol;
  String stackPushSymbol;
  String stackPopSymbol;

  bool isChecking;
  bool isCorrect;

  Operations({
    required this.stackPeakSymbol,
    required this.inputTopSymbol,
    required this.stackPushSymbol,
    required this.stackPopSymbol,
    this.isChecking = false,
    this.isCorrect = false,
  });

  String getInputTopSymbol() {
    return inputTopSymbol.isEmpty ? 'ε' : inputTopSymbol;
  }

  String getStackPeakSymbol() {
    return stackPeakSymbol.isEmpty ? 'ε' : stackPeakSymbol;
  }

  String getStackPushSymbol() {
    return stackPushSymbol.isEmpty ? 'ε' : stackPushSymbol;
  }

  String getStackPopSymbol() {
    return stackPopSymbol.isEmpty ? 'ε' : stackPopSymbol;
  }

  @override
  String toString() {
    return '${getInputTopSymbol()},${getStackPeakSymbol()} -> ${getStackPushSymbol()},${getStackPopSymbol()}';
  }
}
