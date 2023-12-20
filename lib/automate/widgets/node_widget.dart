import 'package:automate_simulator/automate/painters/node_painter.dart';
import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/node_model.dart';

class NodeWidget extends StatefulWidget {
  final NodeModel node;
  NodeModel? selectedNode;
  final Function updatePosition;
  final Function startTransition;
  final Function updateTransition;
  final Function endTransition;

  NodeWidget({
    super.key,
    required this.node,
    required this.updatePosition,
    required this.startTransition,
    required this.updateTransition,
    required this.endTransition,
  });

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: widget.node.location.dx,
            top: widget.node.location.dy,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (details) {
                widget.updatePosition(widget.node, details.delta);
              },
              onTap: () {
                setState(() {
                  widget.selectedNode = widget.node;
                });
              },
              child: CustomPaint(
                painter: NodePainter(widget.node),
                size: const Size(60, 60),
              ),
            )),
        Positioned(
          left: widget.node.rightCirclePosition().dx,
          top: widget.node.rightCirclePosition().dy,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (_) => widget.startTransition(widget.node),
            onPanUpdate: (details) => widget.updateTransition(details),
            onPanEnd: (_) => widget.endTransition(widget.node),
            child: Container(
              width: 20, //
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Positioned(
          left: widget.node.leftCirclePosition().dx,
          top: widget.node.leftCirclePosition().dy,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class TransitionCircleWidget extends StatelessWidget {
  final Offset position;
  final Function onStartTransition;
  final Function onUpdateTransition;
  final Function onEndTransition;

  const TransitionCircleWidget({
    super.key,
    required this.position,
    required this.onStartTransition,
    required this.onUpdateTransition,
    required this.onEndTransition,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: (_) => onStartTransition(),
        onPanUpdate: (details) => onUpdateTransition(details.localPosition),
        onPanEnd: (_) => onEndTransition(),
        child: Container(
          width: 20, // Size of the small circle
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
