import 'package:flutter/material.dart';
import 'package:myapp/classes/rule_class.dart';
import 'package:myapp/classes/turing_machine_class.dart';
import 'package:provider/provider.dart';

class RuleWidget extends StatefulWidget {
  final Rule rule;
  final int ruleIndex;

  const RuleWidget({super.key, required this.rule, required this.ruleIndex});

  @override
  RuleWidgetState createState() => RuleWidgetState();
}

class RuleWidgetState extends State<RuleWidget> {
  late TuringMachine turingMachine;

  @override
  void initState() {
    super.initState();
    turingMachine = Provider.of<TuringMachine>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildRuleIdCircle(widget.rule),
              const SizedBox(width: 8),
              buildTextField(
                label: 'Read',
                onChanged: (value) => setState(() => widget.rule.read = value),
              ),
              const SizedBox(width: 8),
              buildTextField(
                label: 'Write',
                onChanged: (value) => setState(() => widget.rule.write = value),
              ),
              const SizedBox(width: 8),
              buildDirectionDropdown(widget.rule),
              const SizedBox(width: 8),
              buildNextStateDropdown(widget.rule),
              const SizedBox(width: 8),
              buildIconButton(Icons.add, Colors.deepPurple, () => addSubRule()),
              buildIconButton(
                  Icons.check, Colors.deepPurple, () => saveRuleAndSubRules()),
            ],
          ),
          if (widget.rule.subRules.isNotEmpty) buildSubRulesList(widget.rule),
        ],
      ),
    );
  }

  Widget buildRuleIdCircle(Rule rule) {
    return CircleAvatar(
      backgroundColor: Colors.deepPurple[800],
      child: Text(
        '${widget.ruleIndex + 1}',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return Expanded(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget buildDirectionDropdown(Rule rule) {
    return Expanded(
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Direction',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: rule.direction,
            items: ['Right', 'Left'].map((String direction) {
              return DropdownMenuItem<String>(
                value: direction,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.deepPurple[50],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    direction,
                    style: TextStyle(
                      color: Colors.deepPurple[800],
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) =>
                setState(() => rule.direction = value ?? 'Right'),
            dropdownColor: Colors.deepPurple[50],
            style: TextStyle(color: Colors.deepPurple[800], fontSize: 14),
            icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple[800]),
          ),
        ),
      ),
    );
  }

  Widget buildNextStateDropdown(Rule rule) {
    final nodeNames = turingMachine.nodes.map((node) => node.name).toList();

    if (!nodeNames.contains(rule.newState) && nodeNames.isNotEmpty) {
      rule.newState = nodeNames.first;
    }

    return Expanded(
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Next State',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: rule.newState.isEmpty ? nodeNames.first : rule.newState,
            items: nodeNames.map((name) {
              return DropdownMenuItem<String>(
                value: name,
                child: Text(name, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                rule.newState = value ?? nodeNames.first;
              });
            },
            dropdownColor: Colors.deepPurple[50],
            style: TextStyle(color: Colors.deepPurple[800], fontSize: 14),
            icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple[800]),
          ),
        ),
      ),
    );
  }

  Widget buildSubRulesList(Rule rule) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Column(
        children: rule.subRules.map((subRule) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                buildTextField(
                  label: 'Read',
                  onChanged: (value) => setState(() => subRule.read = value),
                ),
                const SizedBox(width: 8),
                buildTextField(
                  label: 'Write',
                  onChanged: (value) => setState(() => subRule.write = value),
                ),
                const SizedBox(width: 8),
                buildDirectionDropdown(subRule),
                const SizedBox(width: 8),
                buildNextStateDropdown(subRule),
                const SizedBox(width: 8),
                buildIconButton(
                  Icons.remove,
                  Colors.red,
                  () => removeSubRuleAndTransition(subRule),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed,
    );
  }

  void addSubRule() {
    setState(() {
      final subRule = Rule(id: widget.rule.id);
      widget.rule.addSubRule(subRule);
    });
  }

  void removeSubRuleAndTransition(Rule subRule) {
    // מחיקת המעבר הספציפי של תת-הרול
    turingMachine.transitions.removeWhere(
      (transition) =>
          transition.from.name == widget.rule.id.toString() &&
          transition.read == subRule.read &&
          transition.write == subRule.write &&
          transition.direction == subRule.direction &&
          transition.to.name == subRule.newState,
    );

    // מחיקת תת-הרול מהרשימה
    setState(() {
      widget.rule.subRules.remove(subRule);
    });

    turingMachine.notifyListeners();

    print("Sub-rule removed and its transition deleted.");
  }

  void saveRuleAndSubRules() {
    // מחיקת מעברים ישנים של הרול הראשי ושל תתי-הרולים
    turingMachine.transitions.removeWhere(
      (transition) => transition.from.name == widget.rule.id.toString(),
    );

    // יצירת מעבר עבור הרול הראשי
    final fromNode = turingMachine.nodes[widget.ruleIndex];
    final toNode = turingMachine.nodes.firstWhere(
      (node) => node.name == widget.rule.newState,
      orElse: () => turingMachine.nodes.first,
    );
    turingMachine.addTransitionForRule(fromNode, toNode, widget.rule);

    // יצירת מעברים עבור תתי-הרולים
    for (var subRule in widget.rule.subRules) {
      final subToNode = turingMachine.nodes.firstWhere(
        (node) => node.name == subRule.newState,
        orElse: () => turingMachine.nodes.first,
      );
      turingMachine.addTransitionForRule(fromNode, subToNode, subRule);
    }

    print("Transitions updated for Rule ID ${widget.rule.id}");
  }
}
