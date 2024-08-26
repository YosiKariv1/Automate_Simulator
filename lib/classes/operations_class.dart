class Operations {
  String inputTopSymbol;
  String stackPopSymbol;
  String stackPushSymbol;

  bool isChecking;
  bool isCorrect;

  Operations({
    required this.inputTopSymbol,
    required this.stackPopSymbol,
    required this.stackPushSymbol,
    this.isChecking = false,
    this.isCorrect = false,
  });

  String getInputTopSymbol() {
    return inputTopSymbol.isEmpty ? 'ε' : inputTopSymbol;
  }

  String getStackPopSymbol() {
    return stackPopSymbol.isEmpty ? 'ε' : stackPopSymbol;
  }

  String getStackPushSymbol() {
    return stackPushSymbol.isEmpty ? 'ε' : stackPushSymbol;
  }

  @override
  String toString() {
    return '${getInputTopSymbol()},${getStackPopSymbol()} | ${getStackPushSymbol()}';
  }
}
