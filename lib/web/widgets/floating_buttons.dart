import 'package:flutter/material.dart';

class FloatingButtons extends StatelessWidget {
  final VoidCallback addNode;
  final VoidCallback deleteNode;
  final VoidCallback playAction;
  final VoidCallback onBack;

  const FloatingButtons({
    super.key,
    required this.addNode,
    required this.deleteNode,
    required this.playAction,
    required this.onBack, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: addNode,
          heroTag: "addNode",
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: deleteNode,
          heroTag: "deleteNode",
          child: const Icon(Icons.delete),
        ),
        FloatingActionButton(
          onPressed: () {},
          heroTag: "Play",
          child: const Icon(Icons.play_arrow),
        ),
        FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          heroTag: "Back",
          child: const Icon(Icons.arrow_back),
        ),
      ],
    );
  }
}
