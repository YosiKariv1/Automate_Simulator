class Rule {
  final int id;
  String currentState;
  String read;
  String write;
  String direction;
  String newState;
  List<Rule> subRules;

  Rule({
    required this.id,
    this.currentState = '',
    this.read = '',
    this.write = '',
    this.direction = 'Right',
    this.newState = '',
  }) : subRules = [];

  void addSubRule(Rule subRule) {
    subRules.add(subRule);
  }
}
