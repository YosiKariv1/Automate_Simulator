import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/transition_model.dart';
import 'package:automate_simulator/automate/controllers/node_controller.dart';
import 'package:automate_simulator/automate/painters/transition_painter.dart';

class AutomateWidget extends StatefulWidget {
  final List<NodeController> nodeControllers;
  final ValueNotifier<List<TransitionModel>> transitionsNotifier;
  final ValueNotifier<TransitionModel?> tempTransitionNotifier;

  const AutomateWidget({
    Key? key,
    required this.nodeControllers,
    required this.transitionsNotifier,
    required this.tempTransitionNotifier,
  }) : super(key: key);

  @override
  _AutomatonWidgetState createState() => _AutomatonWidgetState();
}

class _AutomatonWidgetState extends State<AutomateWidget> {
  @override
  void initState() {
    super.initState();
    widget.tempTransitionNotifier.addListener(_onTempTransitionChanged);
    widget.transitionsNotifier.addListener(_onTransitionsChanged);
  }

  void _onTempTransitionChanged() {
    // Call setState to rebuild the widget with the new tempTransition value
    setState(() {});
  }

  void _onTransitionsChanged() {
    // Call setState to rebuild the widget with the new transitions value
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Builder(
          builder: (context) {
            return CustomPaint(
              painter: TransitionPainter(
                transitions: widget.transitionsNotifier.value,
                tempTransition: widget.tempTransitionNotifier.value,
              ),
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
            );
          },
        ),
        ...widget.nodeControllers.map((nodeController) {
          return nodeController.widget;
        }).toList(),
      ],
    );
  }

  @override
  void dispose() {
    widget.tempTransitionNotifier.removeListener(_onTempTransitionChanged);
    widget.transitionsNotifier.removeListener(_onTransitionsChanged);
    super.dispose();
  }
}
