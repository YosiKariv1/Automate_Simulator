import 'package:flutter/material.dart';
import 'package:myapp/PDA/simulator/pda_simulator.dart';

class SimulationControlPanel extends StatefulWidget {
  late PDASimulation simulator;

  SimulationControlPanel({super.key, required this.simulator});

  @override
  SimulationControlPanelState createState() => SimulationControlPanelState();
}

class SimulationControlPanelState extends State<SimulationControlPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showSpeedSlider = false;
  double _speed = 1.0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSpeedSlider() {
    setState(() {
      _showSpeedSlider = !_showSpeedSlider;
      if (_showSpeedSlider) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressSlider(context),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.play_arrow,
                onPressed: widget.simulator.start,
                tooltip: 'Play',
              ),
              _buildControlButton(
                icon: Icons.stop,
                onPressed: widget.simulator.pda.printPDAState,
                tooltip: 'Stop',
              ),
              _buildControlButton(
                icon: Icons.replay,
                onPressed: widget.simulator.reset,
                tooltip: 'Reset',
              ),
              _buildSpeedControl(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.deepPurple.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildSpeedControl() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.speed, size: 30, color: Colors.deepPurple),
          onPressed: _toggleSpeedSlider,
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.horizontal,
          child: SizedBox(
            width: 120,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5.0,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 14.0),
                activeTrackColor: Colors.deepPurple.shade700,
                inactiveTrackColor: Colors.deepPurple.shade100,
                thumbColor: Colors.deepPurple.shade700,
                overlayColor: Colors.deepPurple.withOpacity(0.2),
              ),
              child: Slider(
                value: _speed,
                min: 0.5,
                max: 2.0,
                divisions: 3,
                label: '${_speed}x',
                onChanged: (value) {
                  setState(() {
                    _speed = value;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSlider(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 5.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
        activeTrackColor: Colors.deepPurple.shade700,
        inactiveTrackColor: Colors.deepPurple.shade100,
        thumbColor: Colors.deepPurple.shade700,
        overlayColor: Colors.deepPurple.withOpacity(0.2),
      ),
      child: Slider(
        value: _progress,
        min: 0,
        max: 1,
        onChanged: (value) {
          setState(() {
            _progress = value;
          });
        },
      ),
    );
  }
}
