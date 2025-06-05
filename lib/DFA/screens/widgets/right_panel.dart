import 'package:flutter/material.dart';
import 'package:automaton_simulator/DFA/info/dfa_table.dart';
import 'package:automaton_simulator/DFA/pages/widgets/panel_container.dart';
import 'package:automaton_simulator/DFA/pages/widgets/enter_word_widget.dart';

class RightPanel extends StatelessWidget {
  final GlobalKey regxKey;
  final GlobalKey infoPanelKey;

  const RightPanel({
    super.key,
    required this.regxKey,
    required this.infoPanelKey,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          _InputWordPanel(regxKey: regxKey),
          _InfoPanel(infoPanelKey: infoPanelKey),
        ],
      ),
    );
  }
}

class _InputWordPanel extends StatelessWidget {
  final GlobalKey regxKey;
  const _InputWordPanel({required this.regxKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: regxKey,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      child: const PanelContainer(
        title: 'Input Word',
        icon: IconButton(
          onPressed: null,
          icon: Icon(Icons.info_outline, color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: EnterWordWidget(),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final GlobalKey infoPanelKey;
  const _InfoPanel({required this.infoPanelKey});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PanelContainer(
        title: 'DFA Information',
        icon: const IconButton(
          onPressed: null,
          icon: Icon(Icons.info_outline, color: Colors.white),
        ),
        containerKey: infoPanelKey,
        scrollable: true,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: const DfaTable(),
      ),
    );
  }
}
