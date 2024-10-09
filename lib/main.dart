import 'package:flutter/material.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/classes/pda_class.dart';
import 'package:automaton_simulator/classes/turing_machine_class.dart';
import 'package:automaton_simulator/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const SimulatorApp());
}

class SimulatorApp extends StatelessWidget {
  const SimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DFA()),
        ChangeNotifierProvider(create: (context) => PDA()),
        ChangeNotifierProvider(create: (context) => TuringMachine()),
      ],
      child: const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
