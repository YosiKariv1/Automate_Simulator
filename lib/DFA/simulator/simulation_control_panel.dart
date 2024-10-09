import 'package:flutter/material.dart';
import 'package:automaton_simulator/DFA/simulator/automaton_validator.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';

class SimulationControlPanel extends StatefulWidget {
  final Simulator simulator;

  const SimulationControlPanel({super.key, required this.simulator});

  @override
  SimulationControlPanelState createState() => SimulationControlPanelState();
}

class SimulationControlPanelState extends State<SimulationControlPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showSpeedSlider = false;

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

  void _handlePlayPause() {
    if (widget.simulator.isPlaying) {
      widget.simulator.pause();
    } else {
      bool isValid = AutomatonValidator.validateAndNotify(
          context, widget.simulator.automaton);
      if (isValid) {
        widget.simulator.play();
      }
    }
    setState(() {});
  }

  void _handleStop() {
    widget.simulator.stop();
    setState(() {});
  }

  void _handleReset() {
    widget.simulator.reset();
    setState(() {});
  }

  void _handleSpeedChange(double speed) {
    widget.simulator.setSpeed(speed);
  }

  void _handleProgressChange(double value) {
    widget.simulator.setProgress(value);
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
                icon:
                    widget.simulator.isPlaying ? Icons.pause : Icons.play_arrow,
                onPressed: _handlePlayPause,
                tooltip: widget.simulator.isPlaying ? 'Pause' : 'Play',
              ),
              _buildControlButton(
                icon: Icons.stop,
                onPressed: _handleStop,
                tooltip: 'Stop',
              ),
              _buildControlButton(
                icon: Icons.replay,
                onPressed: _handleReset,
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
                value: widget.simulator.speed,
                min: 0.5,
                max: 2.0,
                divisions: 3,
                label: '${widget.simulator.speed}x',
                onChanged: _handleSpeedChange,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSlider(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.simulator,
      builder: (context, _, __) {
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
            value: widget.simulator.progress,
            min: 0,
            max: 1,
            onChanged:
                widget.simulator.steps.isEmpty ? null : _handleProgressChange,
          ),
        );
      },
    );
  }
}
