import 'package:flutter/material.dart';
import 'package:automaton_simulator/PDA/simulator/pda_simulator.dart';

class SimulationControlPanel extends StatefulWidget {
  final PDASimulator simulator;

  const SimulationControlPanel({super.key, required this.simulator});

  @override
  SimulationControlPanelState createState() => SimulationControlPanelState();
}

class SimulationControlPanelState extends State<SimulationControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            icon: Icons.play_arrow_rounded,
            label: 'Play Simulation',
            onPressed: widget.simulator.startSimulation,
            color: Colors.deepPurple.shade600,
          ),
          const SizedBox(width: 20),
          _buildActionButton(
            icon: Icons.stop_circle_rounded,
            label: 'Stop Simulation',
            onPressed: widget.simulator.stopSimulation,
            color: Colors.deepPurple.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
