import 'package:flutter/material.dart';

class FloatingButtons extends StatelessWidget {
  final VoidCallback addNode;
  final VoidCallback deleteNode;
  final VoidCallback playAction;
  final VoidCallback onBack;
  final VoidCallback onInfo;

  const FloatingButtons({
    super.key,
    required this.addNode,
    required this.deleteNode,
    required this.playAction,
    required this.onBack,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width * 0.08),
              child: FloatingActionButton(
                onPressed: onBack,
                heroTag: 'backButton',
                child: const Icon(Icons.arrow_back),
              ),
            ),
            FloatingActionButton(
              onPressed: onInfo,
              heroTag: 'infoButton',
              child: const Icon(Icons.info),
            ),
            //
          ],
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08),
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
        ),
      )
    ]);
  }
}
