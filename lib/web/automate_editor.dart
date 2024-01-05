import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:automate_simulator/automate/painters/transition_painter.dart';
import 'package:automate_simulator/automate/widgets/node_widget.dart';
import './widgets/floating_buttons.dart';

class AutomateEditorWeb extends StatefulWidget {
  const AutomateEditorWeb({super.key});

  @override
  State<AutomateEditorWeb> createState() => _AutomateEditorWebState();
}

class _AutomateEditorWebState extends State<AutomateEditorWeb> {
  Offset? from;
  Offset? to;
  Transition? tempTransition;
  List<Transition> transitions = [];
  List<NodeModel> nodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 135, 203, 46),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingButtons(
            addNode: addNode,
            deleteNode: deleteNode,
            playAction: () {},
            onBack: () {
              Navigator.pop(context);
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              color: const Color.fromARGB(255, 205, 240, 159),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 10.0,
              margin: const EdgeInsets.all(10),
              child: Stack(children: [
                GestureDetector(
                  onTapUp: _onCanvasTap,
                  child: CustomPaint(
                    painter: TransitionPainter(
                        transitions: transitions,
                        tempTransition: tempTransition),
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                  ),
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
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.7,
              margin: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
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
        renderBox.globalToLocal(details.globalPosition - const Offset(100, 10));

    setState(() {
      to = localPosition;
      tempTransition = Transition(
        from!,
        to!,
      );
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
          title: const Text('Edit Transition Text'),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  transition.alphabet = controller.text;
                  // Redraw the transitions with updated text
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
