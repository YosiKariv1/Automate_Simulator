import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:automate_simulator/automate/painters/transition_painter.dart';
import 'package:automate_simulator/automate/widgets/node_widget.dart';
import 'package:automate_simulator/mobile/widgets/floating_buttons.dart';
import 'package:automate_simulator/automate/models/automate_model.dart';

class AutomateEditorMobile extends StatefulWidget {
  final AutomateModel automateModel;
  const AutomateEditorMobile({super.key, required this.automateModel});

  @override
  State<AutomateEditorMobile> createState() => _AutomateEditorMobileState();
}

class _AutomateEditorMobileState extends State<AutomateEditorMobile> {
  Offset? from;
  Offset? to;
  Transition? tempTransition;
  List<Transition> transitions = [];

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
        GestureDetector(
          onTapUp: _onCanvasTap,
          child: CustomPaint(
            painter: TransitionPainter(
                transitions: transitions, tempTransition: tempTransition),
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
          ),
        ),
        ...widget.automateModel.nodes.map((node) {
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
      widget.automateModel.nodes.add(NodeModel(
          name: 'q${widget.automateModel.nodes.length}',
          location: const Offset(200, 200),
          next: {},
          ifFinal: false));
    });
    if (kDebugMode) {
      print('Adding node:${widget.automateModel.nodes.last.name}');
    }
  }

  void updatePosition(NodeModel node, Offset newPos) {
    setState(() {
      int index = widget.automateModel.nodes.indexOf(node);
      if (index != -1) {
        widget.automateModel.nodes[index].location += newPos;
      }
    });
  }

  void deleteNode() {
    setState(() {
      NodeModel nodeToDelete = widget.automateModel.nodes.last;
      widget.automateModel.nodes.removeLast();

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
        //adding the next node to the array of the current node
        node.next![targetNode.name] = targetNode;
      });
    } else {
      setState(() {
        tempTransition = null;
      });
    }
  }

  NodeModel? findNodeAtPosition(Offset position) {
    for (var node in widget.automateModel.nodes) {
      if ((position - node.leftCirclePosition()).distance <= 30) {
        return node;
      }
    }
    return null;
  }

//=================================== Clicking on the line and Dialog box ================================//

  void _onCanvasTap(TapUpDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(details.globalPosition);

    for (var transition in transitions) {
      if (transition.textRect != null &&
          transition.textRect!.contains(localPosition)) {
        if (kDebugMode) {
          print("Canvas tapped");
        }
        _editTransitionText(transition);
        break;
      }
    }
  }

  void _editTransitionText(Transition transition) {
    final TextEditingController controller =
        TextEditingController(text: transition.alphabet);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chose a letter'),
          content: Column(children: [
            TextField(
              controller: controller,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {}, child: const Text('A')),
                TextButton(onPressed: () {}, child: const Text('B')),
                TextButton(onPressed: () {}, child: const Text('C')),
              ],
            )
          ]),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  transition.alphabet = controller.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
