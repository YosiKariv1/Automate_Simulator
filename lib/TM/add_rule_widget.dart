import 'package:flutter/material.dart';
import 'package:automaton_simulator/TM/widgets/rule_widget.dart';
import 'package:automaton_simulator/classes/rule_class.dart';
import 'package:automaton_simulator/classes/turing_machine_class.dart';
import 'package:provider/provider.dart';

class AddRuleWidget extends StatefulWidget {
  const AddRuleWidget({super.key});

  @override
  AddRuleWidgetState createState() => AddRuleWidgetState();
}

class AddRuleWidgetState extends State<AddRuleWidget> {
  final ScrollController _scrollController = ScrollController();
  late TuringMachine turingMachine;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    turingMachine = Provider.of<TuringMachine>(context);
  }

  void addRule() {
    turingMachine.addRule(Rule(id: turingMachine.rules.length + 1));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void removeLastRule() {
    turingMachine.deleteRule(turingMachine.rules.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.deepPurple.shade500,
          width: 4.0,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10.0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (turingMachine.rules.isEmpty)
            buildEmptyState()
          else
            buildRulesList(),
          if (turingMachine.rules.isNotEmpty) buildActionButtons(),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Expanded(
      child: Center(
        child: buildAddRuleButton(),
      ),
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildAddRuleButton(),
        const SizedBox(width: 16),
        buildDeleteLastRuleButton(),
      ],
    );
  }

  Widget buildAddRuleButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Add Rule',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Colors.deepPurple[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onPressed: addRule,
    );
  }

  Widget buildDeleteLastRuleButton() {
    return ElevatedButton.icon(
      onPressed: removeLastRule,
      icon: const Icon(Icons.delete, color: Colors.white),
      label: const Text(
        'Delete Last Rule',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Colors.deepPurple[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget buildRulesList() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: turingMachine.rules.length,
        itemBuilder: (context, index) {
          return RuleWidget(
            rule: turingMachine.rules[index],
            ruleIndex: index,
          );
        },
      ),
    );
  }
}
