import 'package:automate_simulator/automate/models/transition_model.dart';
import 'package:automate_simulator/automate/widgets/automate_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/automate_model.dart';
import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:automate_simulator/automate/controllers/node_controller.dart';

class AutomateController {
  AutomateModel model = AutomateModel();
  late AutomateWidget widget;
  List<NodeController> nodeControllers = [];
  ValueNotifier<List<TransitionModel>> transitionsNotifier = ValueNotifier([]);
  ValueNotifier<TransitionModel?> tempTransitionNotifier = ValueNotifier(null);
  Offset? from;
  Offset? to;

  AutomateController() {
    widget = AutomateWidget(
      nodeControllers: nodeControllers,
      transitionsNotifier: transitionsNotifier,
      tempTransitionNotifier: tempTransitionNotifier,
    );
  }
  void addNode() {
    var newNodeController = NodeController(
      name: 'q${nodeControllers.length}',
      ifFinal: false,
      next: {},
      onUpdatePosition: updatePosition,
      onStartTransition: startTransition,
      onUpdateTransition: updateTransition,
      onEndTransition: endTransition,
    );
    model.addNode(newNodeController.model);
    nodeControllers.add(newNodeController);
    // Rebuild the AutomateWidget with the updated list of NodeWidgets
    widget = AutomateWidget(
        nodeControllers: nodeControllers,
        transitionsNotifier: transitionsNotifier,
        tempTransitionNotifier: tempTransitionNotifier);
  }

  void deleteNode() {
    var node = nodeControllers.removeLast();
    model.transitions.removeWhere((transition) =>
        transition.node == node.model || transition.target == node.model);
    widget = AutomateWidget(
        nodeControllers: nodeControllers,
        transitionsNotifier: transitionsNotifier,
        tempTransitionNotifier: tempTransitionNotifier);
  }

  // Method to update the position of a node, called by NodeController
  void updatePosition(NodeModel node, Offset newPos) {
    var index = model.nodes.indexOf(node);
    NodeController nodeController =
        nodeControllers.firstWhere((controller) => controller.model == node);
    if (index != -1) {
      nodeController.positionNotifier.value += newPos;
    }
    for (var transition in transitionsNotifier.value) {
      if (transition.node == node) {
        transition.start += newPos;
      }
      if (transition.target == node) {
        transition.end += newPos;
      }
    }
    if (kDebugMode) {
      print(
          'Node: ${nodeController.model.name}, Position: ${nodeController.positionNotifier.value}, LeftCircle: ${nodeController.leftCirclePosition}, RightCircle: ${nodeController.rightCirclePosition},');
    }
  }

  void startTransition(NodeModel node) {
    if (kDebugMode) {
      print("Start transition");
    }
    from = nodeControllers
            .firstWhere((controller) => controller.model == node)
            .rightCirclePosition +
        const Offset(10, 10);
    tempTransitionNotifier.value = TransitionModel(from!, from!);
    if (kDebugMode) {
      print("from: $from");
    }
  }

  void updateTransition(DragUpdateDetails details, RenderBox renderBox) {
    Offset localposition =
        renderBox.globalToLocal(details.globalPosition - const Offset(-10, 0));
    to = localposition;
    tempTransitionNotifier.value = TransitionModel(from!, to!);

    if (kDebugMode) {
      print("to: $to");
    }
  }

  void endTransition(NodeModel nodeStart, RenderBox renderBox) {
    if (kDebugMode) {
      print("End transition");
    }
    NodeController? targetNodeController = findNodeAtPosition(to!);
    NodeController startNodeController = nodeControllers
        .firstWhere((controller) => controller.model == nodeStart);

    if (targetNodeController != null) {
      TransitionModel newTransition = TransitionModel(
        startNodeController.rightCirclePosition,
        targetNodeController.leftCirclePosition,
        node: startNodeController.model,
        target: targetNodeController.model,
      );
      transitionsNotifier.value.add(newTransition);
      widget = AutomateWidget(
          nodeControllers: nodeControllers,
          transitionsNotifier: transitionsNotifier,
          tempTransitionNotifier: tempTransitionNotifier);
    }

    tempTransitionNotifier.value = null;
    if (kDebugMode) {
      print("start: ${startNodeController.model.name}");
    }
    if (kDebugMode) {
      print("target: ${targetNodeController?.model.name}");
    }
  }

  NodeController? findNodeAtPosition(Offset position) {
    for (var node in widget.nodeControllers) {
      if ((position - node.leftCirclePosition).distance <= 30) {
        return node;
      }
    }
    return null;
  }
}
