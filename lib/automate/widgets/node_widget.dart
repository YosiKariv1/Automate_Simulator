import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/node_model.dart';

class NodeWidget extends StatefulWidget {
  final NodeModel node;
  final ValueNotifier<Offset> positionNotifier;
  final Function updatePosition;
  final Function startTransition;
  final Function updateTransition;
  final Function endTransition;

  NodeWidget({
    Key? key,
    required this.node,
    required this.positionNotifier,
    required this.updatePosition,
    required this.startTransition,
    required this.updateTransition,
    required this.endTransition,
  }) : super(key: key);

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
        valueListenable: widget.positionNotifier,
        builder: (context, position, child) {
          return Stack(
            children: [
              buildNode(),
              buildSidesCircle(rightCirclePosition(), onPanStart: (_) {
                widget.startTransition(widget.node);
              }, onPanUpdate: (details) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                widget.updateTransition(details, renderBox);
              }, onPanEnd: (_) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                widget.endTransition(widget.node, renderBox);
              }),
              buildSidesCircle(leftCirclePosition(), onTap: () {}),
            ],
          );
        });
  }

  Widget buildNode() => Positioned(
        left: widget.positionNotifier.value.dx,
        top: widget.positionNotifier.value.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              widget.updatePosition(widget.node, details.delta);
            });
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 135, 203, 46),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.node.name,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
        ),
      );
  Widget buildSidesCircle(
    Offset position, {
    VoidCallback? onTap,
    void Function(DragStartDetails)? onPanStart,
    void Function(DragUpdateDetails)? onPanUpdate,
    void Function(DragEndDetails)? onPanEnd,
  }) =>
      Positioned(
        left: position.dx,
        top: position.dy,
        child: GestureDetector(
          onTap: onTap,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ),
      );

  Offset rightCirclePosition() => Offset(widget.positionNotifier.value.dx + 50,
      widget.positionNotifier.value.dy + 20);

  Offset leftCirclePosition() => Offset(widget.positionNotifier.value.dx - 10,
      widget.positionNotifier.value.dy + 20);
}
