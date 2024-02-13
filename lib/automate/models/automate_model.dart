import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:automate_simulator/automate/models/transition_model.dart';

class AutomateModel {
  List<NodeModel> nodes = [];
  List<TransitionModel> transitions = [];
  List<String> alphabet = [];
  NodeModel? startNode;

  void addNode(NodeModel node) {
    nodes.add(node);
    if (nodes.length == 1) startNode = node;
  }

  void removeNode(NodeModel node) {
    nodes.remove(node);
    transitions.removeWhere((t) => t.node == node || t.target == node);
  }

  void addTransition(TransitionModel transition) {
    transitions.add(transition);
  }

  void removeTransition(TransitionModel transition) {
    transitions.remove(transition);
  }
}
