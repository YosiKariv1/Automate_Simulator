import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:provider/provider.dart';

class DfaInfoWidget extends StatelessWidget {
  const DfaInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DFA>(
      builder: (context, automaton, child) {
        // --- EMPTY STATE CARD ---
        if (automaton.nodes.isEmpty) {
          return _buildEmptyStateCard();
        }
        // --- MAIN DFA INFO ---
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard([
                  _buildInfoRow('States (Q)',
                      automaton.nodes.map((n) => n.name).join(', ')),
                  _buildInfoRow(
                      'Alphabet (Σ)',
                      automaton.getAlphabet().isEmpty
                          ? 'Not set'
                          : automaton.getAlphabet()),
                  _buildInfoRow(
                      'Initial State (q0)', automaton.nodes.first.name),
                  _buildInfoRow(
                      'Accepting States (F)', _getAcceptStates(automaton)),
                ]),
                const SizedBox(height: 24),
                _buildTransitionTable(automaton),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- EMPTY STATE CARD ---
  Widget _buildEmptyStateCard() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.info_outline,
                  size: 52, color: Colors.deepPurple.shade300),
              const SizedBox(height: 15),
              Text(
                'No Automaton Data',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Add states and transitions in the editor to view details here.',
                style: GoogleFonts.poppins(
                  fontSize: 15.5,
                  color: Colors.grey.shade600,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '💡 Tip: Click "Add Node" to create your first state.',
                style: GoogleFonts.poppins(
                  fontSize: 13.2,
                  color: Colors.deepPurple.shade400,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- INFO CARD ---
  Widget _buildInfoCard(List<Widget> content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content,
        ),
      ),
    );
  }

  // --- INFO ROW ---
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: GoogleFonts.roboto()),
          ),
        ],
      ),
    );
  }

  // --- TRANSITION TABLE ---
  Widget _buildTransitionTable(DFA automaton) {
    if (automaton.transitions.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No transitions defined',
              style:
                  GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    List<String> states = automaton.nodes.map((n) => n.name).toList();
    List<String> alphabetChars = automaton.alphabet.split('');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transition Table (δ)',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: DataTable(
                        dataRowMinHeight: 48,
                        headingRowHeight: 56,
                        border: TableBorder.all(
                          color: Colors.deepPurple.shade300,
                          width: 1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: [
                          DataColumn(
                            label: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('Q/Σ',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          ...alphabetChars.map((char) => DataColumn(
                                label: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(char,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ],
                        rows: states.map((state) {
                          return DataRow(
                            cells: [
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      minHeight: 48, maxHeight: 56),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(state,
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              ...alphabetChars.map((char) {
                                String nextState =
                                    _getNextState(automaton, state, char);
                                return DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        minHeight: 48, maxHeight: 56),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(nextState,
                                          style: GoogleFonts.roboto()),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- UTILS ---
  String _getNextState(DFA automaton, String currentState, String symbol) {
    for (var transition in automaton.transitions) {
      if (transition.from.name == currentState &&
          transition.symbol.contains(symbol)) {
        return transition.to.name;
      }
    }
    return '-';
  }

  String _getAcceptStates(DFA automaton) {
    var acceptStates =
        automaton.nodes.where((n) => n.isAccepting).map((n) => n.name).toList();
    return acceptStates.isNotEmpty ? acceptStates.join(', ') : 'None';
  }
}
