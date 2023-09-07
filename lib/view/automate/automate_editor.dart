import 'package:automate_simulator/view/automate/custom_paint_circle.dart';
import 'package:flutter/material.dart';

class AutomateEditor extends StatefulWidget {
  const AutomateEditor({super.key});

  @override
  State<AutomateEditor> createState() => _AutomateEditorState();
}

class _AutomateEditorState extends State<AutomateEditor> {
  List<Offset?> circleOffsets = [];
  double offsetIndexDX = 80;

  void updatePosition(int index, Offset newPosition) {
    setState(() {
      circleOffsets[index] = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            circleOffsets.add(Offset(offsetIndexDX, 100));
            offsetIndexDX += 10;
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: NodePaint(circleOffsets),
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
          ),
          ...List.generate(
            circleOffsets.length,
            (index) => circleOffsets[index] != null
                ? Positioned(
                    left: circleOffsets[index]!.dx - 10,
                    top: circleOffsets[index]!.dy - 10,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        updatePosition(
                            index, circleOffsets[index]! + details.delta);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
