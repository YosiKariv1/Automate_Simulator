import 'package:flutter/material.dart';
import 'package:myapp/classes/automaton_class.dart';
import 'package:myapp/classes/turing_machine_class.dart';
import 'package:myapp/home_page.dart';
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
        ChangeNotifierProvider(create: (context) => Automaton()),
        ChangeNotifierProvider(create: (context) => TuringMachine()),
      ],
      child: const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
