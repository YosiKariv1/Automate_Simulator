import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:provider/provider.dart';

class NodeWidget extends StatelessWidget {
  const NodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Node>(
      builder: (context, node, child) {
        return Stack(children: [
          Positioned(
            left: node.position.dx,
            top: node.position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                final newPosition = node.position + details.delta;
                node.updatePosition(newPosition);
              },
              child: buildNode(node, node.nodeSize),
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
            child: buildSideCircle(node.smallCircleSize),
          ),
        ]);
      },
    );
  }

  Widget buildNode(Node node, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: node.isInSimulation ? Colors.green : Colors.deepPurple[800],
        shape: BoxShape.circle,
        boxShadow: node.isInSimulation
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.8),
                  spreadRadius: 8,
                  blurRadius: 16,
                ),
              ]
            : [],
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
