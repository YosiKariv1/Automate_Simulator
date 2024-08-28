import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/classes/dfa_class.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:provider/provider.dart';

class NodeWidget extends StatelessWidget {
  const NodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Node>(
      builder: (context, node, child) {
        Offset localPosition = Offset.zero;
        DFA automaton = Provider.of<DFA>(context, listen: false);

        return Stack(
          children: [
            Positioned(
              left: node.position.dx,
              top: node.position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  final newPosition = node.position + details.delta;
                  node.updatePosition(newPosition);
                },
                onDoubleTap: () {
                  node.toggleAcceptingState();
                  automaton.notifyListeners();
                },
                child: AnimatedBuilder(
                  animation: node,
                  builder: (context, child) {
                    return buildNode(node, node.nodeSize);
                  },
                ),
              ),
            ),
            Positioned(
              left: node.leftSideNode.dx,
              top: node.leftSideNode.dy,
              child: buildSideCircle(node.smallCircleSize),
            ),
            Positioned(
              left: node.rightSideNode.dx,
              top: node.rightSideNode.dy,
              child: GestureDetector(
                onPanStart: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset localPosition =
                      renderBox.globalToLocal(details.globalPosition);
                  automaton.startTransition(node, localPosition);
                },
                onPanUpdate: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  localPosition =
                      renderBox.globalToLocal(details.globalPosition);
                  automaton.updateTransition(localPosition);
                },
                onPanEnd: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  localPosition =
                      renderBox.globalToLocal(details.globalPosition);
                  automaton.endTransition(node, localPosition, context);
                },
                child: buildSideCircle(node.smallCircleSize),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildNode(Node node, double size) {
    Color nodeColor;
    if (node.isPermanentHighlighted) {
      nodeColor = Colors.green;
    } else if (node.isInSimulation) {
      nodeColor = node.isAccepting ? Colors.green : Colors.red;
    } else {
      nodeColor = Colors.deepPurple[800]!;
    }

    if (node.isError) {
      nodeColor = Colors.red;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: nodeColor,
        shape: BoxShape.circle,
        border: Border.all(
          color:
              (node.isAccepting ? Colors.blueGrey[500]! : Colors.transparent),
          width: 4,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        boxShadow:
            (node.isInSimulation || node.isPermanentHighlighted || node.isError)
                ? [
                    BoxShadow(
                        color: nodeColor.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5)
                  ]
                : null,
      ),
      child: Center(
        child: Text(
          node.name,
          style: GoogleFonts.rajdhani(
            fontSize: 22,
            color: Colors.white,
            fontWeight: (node.isInSimulation || node.isPermanentHighlighted)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget buildSideCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}