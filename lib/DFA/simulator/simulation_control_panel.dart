import 'package:flutter/material.dart';
import 'package:automaton_simulator/DFA/simulator/automaton_validator.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: FaIcon(
              widget.simulator.isPlaying
                  ? FontAwesomeIcons.pause
                  : FontAwesomeIcons.play,
              size: 32,
            ),
            tooltip: widget.simulator.isPlaying ? 'Pause' : 'Play',
            onPressed: _handlePlayPause,
            color: Colors.deepPurple.shade700,
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.stop, size: 26),
            tooltip: 'Stop',
            onPressed: _handleStop,
            color: Colors.deepPurple,
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rotateLeft, size: 26),
            tooltip: 'Reset',
            onPressed: _handleReset,
            color: Colors.deepPurple,
          ),
          const SizedBox(width: 10),
          _buildSpeedControl(),
          const SizedBox(width: 20),
          Expanded(child: _buildProgressSlider(context)),
        ],
      ),
    );
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
    setState(() {
      widget.simulator.setSpeed(speed);
    });
  }

  void _handleProgressChange(double value) {
    widget.simulator.setProgress(value);
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
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: Colors.deepPurple.shade700,
          shadowColor: Colors.deepPurple.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          elevation: 4,
        ),
        child: Icon(icon, color: Colors.white, size: 25),
      ),
    );
  }

  Widget _buildSpeedControl() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.gaugeHigh,
              size: 28, color: Colors.deepPurple),
          onPressed: _toggleSpeedSlider,
          tooltip: 'Adjust Speed',
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
                overlayColor: Colors.deepPurple,
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
        final currentStep =
            (widget.simulator.progress * widget.simulator.steps.length).floor();
        final totalSteps = widget.simulator.steps.length;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              totalSteps == 0 ? '0 / 0' : '$currentStep / $totalSteps',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
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
                  value: widget.simulator.progress,
                  min: 0,
                  max: 1,
                  onChanged: totalSteps == 0 ? null : _handleProgressChange,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
