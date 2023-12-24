import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:automate_simulator/automate/painters/transition_painter.dart';
import 'package:automate_simulator/automate/widgets/node_widget.dart';
import 'package:automate_simulator/automate/widgets/floating_buttons.dart';

class AutomateEditor extends StatefulWidget {
  const AutomateEditor({super.key});

  @override
  State<AutomateEditor> createState() => _AutomateEditorState();
}

class _AutomateEditorState extends State<AutomateEditor> {
  Offset? from;
  Offset? to;
  Transition? tempTransition;
  List<Transition> transitions = [];
  List<NodeModel> nodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 205, 240, 159),
      floatingActionButton: FloatingButtons(
        addNode: addNode,
        deleteNode: deleteNode,
        playAction: () {},
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(children: [
        CustomPaint(
          painter: TransitionPainter(
              transitions: transitions, tempTransition: tempTransition),
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
        ),
        ...nodes.map((node) {
          return NodeWidget(
            node: node,
            updatePosition: updatePosition,
            startTransition: startTransition,
            updateTransition: updateTransition,
            endTransition: endTransition,
          );
        }).toList(),
      ]),
    );
  }

//====================================== Nodes Functions ====================================//
  void addNode() {
    setState(() {
      nodes.add(NodeModel(
          name: 'q${nodes.length}',
          location: const Offset(100, 100),
          next: {},
          ifFinal: false));
    });
  }

  void updatePosition(NodeModel node, Offset newPos) {
    setState(() {
      int index = nodes.indexOf(node);
      if (index != -1) {
        nodes[index].location += newPos;
      }
    });
  }

  void deleteNode() {
    setState(() {
      NodeModel nodeToDelete = nodes.last;
      nodes.removeLast();

      transitions.removeWhere((transition) =>
          transition.node == nodeToDelete || transition.target == nodeToDelete);
    });
  }

  //==================================== Lines Between Nodes ====================================//
  void startTransition(NodeModel node) {
    setState(() {
      from = node.rightCirclePosition() + const Offset(10, 10);
      tempTransition = Transition(from!, from!);
    });
  }

  void updateTransition(DragUpdateDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition =
        renderBox.globalToLocal(details.globalPosition - const Offset(-10, 0));

    setState(() {
      to = localPosition;
      tempTransition = Transition(from!, to!);
    });
  }

  void endTransition(NodeModel node) {
    NodeModel? targetNode = findNodeAtPosition(to!);
    if (targetNode != null) {
      setState(() {
        transitions.add(Transition(from!, targetNode.leftCirclePosition(),
            node: node, target: targetNode));
        tempTransition = null;
        node.next![targetNode.name] = targetNode;
      });
    } else {
      setState(() {
        tempTransition = null;
      });
    }
  }

  NodeModel? findNodeAtPosition(Offset position) {
    for (var node in nodes) {
      if ((position - node.leftCirclePosition()).distance <= 30) {
        return node;
      }
    }
    return null;
  }
}
