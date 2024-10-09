import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:automaton_simulator/DFA/pages/dfa_page.dart';
import 'package:automaton_simulator/PDA/pda_page.dart';
import 'package:automaton_simulator/TM/tm_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                _buildSimulatorOptions(context),
                _buildFeatures(),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade500],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Educational Automaton Simulator',
              style: GoogleFonts.rajdhani(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Learn and Explore Various Automaton Models',
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatorOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Text(
            'Choose a Simulator:',
            style: GoogleFonts.rubik(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildSimulatorCard(
                context,
                'DFA',
                'Finite Automaton',
                Icons.account_tree,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DfaPage()),
                ),
              ),
              _buildSimulatorCard(
                context,
                'PDA',
                'Pushdown Automaton',
                Icons.storage,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PdaPage()),
                ),
              ),
              _buildSimulatorCard(
                context,
                'TM',
                'Turing Machine',
                Icons.computer,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TmPage()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'This simulator helps you understand the concepts of different automaton models. Choose a simulator to get started.',
            style: GoogleFonts.rubik(
              fontSize: 16,
              color: Colors.deepPurple[800],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSimulatorCard(BuildContext context, String title,
      String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          alignment: Alignment.center,
          height: 250,
          width: 400,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.rubik(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: Colors.grey[100],
      child: Column(
        children: [
          Text(
            'Features',
            style: GoogleFonts.rubik(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureItem(
                'Interactive Simulations',
                'Visualize automata in action with step-by-step animations',
                Icons.play_circle_fill,
              ),
              _buildFeatureItem(
                'Comprehensive Tutorials',
                'Learn the theory behind each computational model',
                Icons.school,
              ),
              _buildFeatureItem(
                'Custom Automata Creation',
                'Design and test your own automata with an intuitive interface',
                Icons.edit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.deepPurple[600]),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.deepPurple[900],
      child: Center(
        child: Text(
          '© 2024 Automata Simulator. All rights reserved.',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
