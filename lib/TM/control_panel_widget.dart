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
    extends State<TuringSimulationControlPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showSpeedSlider = false;
  double spaceArea = 300;

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
    widget.simulator.addListener(_onSimulatorUpdate);
  }

  @override
  void dispose() {
    widget.simulator.removeListener(_onSimulatorUpdate);
    _controller.dispose();
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProgressSlider(context),
                const SizedBox(height: 5),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: widget.simulator.isPaused
                            ? Icons.play_arrow
                            : Icons.pause,
                        onPressed: _handlePlayPause,
                        tooltip: widget.simulator.isPaused ? 'Play' : 'Pause',
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

  void _handleReset() {
    widget.simulator.reset();
    setState(() {});
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

  void _handleSpeedChange(double speed) {
    widget.simulator.setSpeed(speed);
    setState(() {});
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
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.deepPurple[700],
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
          icon: const Icon(Icons.speed, size: 30),
          onPressed: _toggleSpeedSlider,
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.horizontal,
          child: SizedBox(
            width: 120,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.teal[700],
                inactiveTrackColor: Colors.teal[200],
                thumbColor: Colors.deepPurple[700],
                trackHeight: 5.0,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 14.0),
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
    double sliderValue = 0.0;
    if (widget.simulator.steps.isNotEmpty &&
        widget.simulator.currentStepIndex >= 0) {
      sliderValue = widget.simulator.currentStepIndex /
          (widget.simulator.steps.length - 1).clamp(1, double.infinity);
    }

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.deepPurple[700],
        inactiveTrackColor: Colors.deepPurple[200],
        thumbColor: Colors.deepPurple[700],
        trackHeight: 5.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
      ),
      child: Slider(
        value: sliderValue,
        min: 0,
        max: 1,
        onChanged: (value) {
          if (widget.simulator.steps.isNotEmpty) {
            double progress = value;
            widget.simulator.setProgress(progress);
          }
        },
      ),
    );
  }
}
