import 'package:automate_simulator/view/automate/custom_paint_circle.dart';
import 'package:flutter/material.dart';

class AutomateEditor extends StatefulWidget {
  const AutomateEditor({super.key});

  @override
  State<AutomateEditor> createState() => _AutomateEditorState();
}

class _AutomateEditorState extends State<AutomateEditor> {
  List<Offset?> circleOffsets = [];
  double offsetDX = 80;

  void updatePosition(int index, Offset newPosition) {
    setState(() {
      circleOffsets[index] = newPosition;
    });
  }

  void addCircle() {
    setState(() {
      circleOffsets.add(Offset(offsetDX, 100));
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCircle();
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
          // //check this part, how it works
          ...List.generate(
            circleOffsets.length,
            (index) => circleOffsets[index] != null
                ? Positioned(
                    left: circleOffsets[index]!.dx - 20,
                    top: circleOffsets[index]!.dy - 20,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        updatePosition(
                            index, circleOffsets[index]! + details.delta);
                      },
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Text("q" + index.toString()),
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
