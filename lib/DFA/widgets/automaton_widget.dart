import 'package:flutter/material.dart';
import 'package:myapp/classes/dfa_class.dart';
import 'package:myapp/DFA/widgets/node_widget.dart';
import 'package:myapp/DFA/widgets/transition_widget.dart';
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
