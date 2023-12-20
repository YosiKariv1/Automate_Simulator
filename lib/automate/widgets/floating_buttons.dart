import 'package:flutter/material.dart';

class FloatingButtons extends StatelessWidget {
  final VoidCallback addNode;
  final VoidCallback deleteNode;
  final VoidCallback playAction;

  const FloatingButtons({
    super.key,
    required this.addNode,
    required this.deleteNode,
    required this.playAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
          child: FloatingActionButton(
            onPressed: addNode,
            heroTag: 'addNodeButton',
            child: const Icon(Icons.add),
          ),
        ),
        FloatingActionButton(
          onPressed: playAction,
          heroTag: 'playButton',
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Icon(Icons.play_arrow),
        ),
        FloatingActionButton(
          onPressed: deleteNode,
          backgroundColor: Colors.red,
          heroTag: 'deleteNodeButton',
          child: const Icon(Icons.delete),
        ),
      ],
    );
  }
}
