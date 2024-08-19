import 'package:flutter/material.dart';
import 'package:myapp/classes/automaton_class.dart';
import 'package:myapp/widgets/node_widget.dart';
import 'package:myapp/widgets/transition_widget.dart';
import 'package:provider/provider.dart';

class AutomatonWidget extends StatelessWidget {
  const AutomatonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Automaton>(
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
