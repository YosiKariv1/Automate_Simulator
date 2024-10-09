import 'package:flutter/material.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/DFA/widgets/node_widget.dart';
import 'package:automaton_simulator/DFA/widgets/transition_widget.dart';
import 'package:provider/provider.dart';

class AutomatonWidget extends StatelessWidget {
  const AutomatonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DFA>(
      builder: (context, automaton, child) {
        return Stack(
          children: [
            const TransitionWidget(),
            ...automaton.nodes.map((node) {
              return ChangeNotifierProvider.value(
                value: node,
                child: const NodeWidget(),
              );
            }),
          ],
        );
      },
    );
  }
}
