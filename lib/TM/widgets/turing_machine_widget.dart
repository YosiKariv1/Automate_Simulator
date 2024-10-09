import 'package:flutter/material.dart';
import 'package:automaton_simulator/TM/widgets/transition_widget.dart';
import 'package:automaton_simulator/classes/turing_machine_class.dart';
import 'package:automaton_simulator/TM/widgets/node_widget.dart';
import 'package:provider/provider.dart';

class TuringMachineWidget extends StatelessWidget {
  const TuringMachineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TuringMachine>(
      builder: (context, turingMachine, child) {
        return Stack(
          children: [
            const TuringTransitionWidget(),
            ...turingMachine.nodes.map((node) {
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
