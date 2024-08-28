import 'package:flutter/material.dart';
import 'package:myapp/TM/simulator/tm_simulator.dart';

class TuringSimulationControlPanel extends StatefulWidget {
  final TuringSimulator simulator;

  const TuringSimulationControlPanel({super.key, required this.simulator});

  @override
  TuringSimulationControlPanelState createState() =>
      TuringSimulationControlPanelState();
}

class TuringSimulationControlPanelState
    extends State<TuringSimulationControlPanel> {
  double spaceArea = 300;

  @override
  void initState() {
    super.initState();
    widget.simulator.addListener(_onSimulatorUpdate);
  }

  @override
  void dispose() {
    widget.simulator.removeListener(_onSimulatorUpdate);
    super.dispose();
  }

  void _onSimulatorUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: spaceArea),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Colors.deepPurple.shade500,
                width: 4.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.play_arrow_rounded,
                  label: 'Play Simulation',
                  onPressed: _handlePlayPause,
                  color: Colors.deepPurple.shade600,
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  icon: Icons.stop_circle_rounded,
                  label: 'Stop Simulation',
                  onPressed: _handleStop,
                  color: Colors.deepPurple.shade400,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: spaceArea),
      ],
    );
  }

  void _handlePlayPause() {
    if (widget.simulator.isPaused) {
      widget.simulator.playPause();
    } else {
      widget.simulator.pause();
    }
    setState(() {});
  }

  void _handleStop() {
    widget.simulator.stop();
    setState(() {});
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
