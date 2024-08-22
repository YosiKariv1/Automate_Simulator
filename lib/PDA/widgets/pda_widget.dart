import 'package:flutter/material.dart';
import 'package:myapp/PDA/widgets/node_widget.dart';
import 'package:myapp/PDA/widgets/transition_widget.dart';
import 'package:myapp/classes/pda_class.dart';
import 'package:provider/provider.dart';

class PDAWidget extends StatelessWidget {
  const PDAWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PDA>(
      builder: (context, automaton, child) {
        return Stack(
          children: [
            const PDATransitionWidget(),
            ...automaton.nodes.map((node) {
              return ChangeNotifierProvider.value(
                value: node,
                child: const PDANodeWidget(),
              );
            }),
          ],
        );
      },
    );
  }
}