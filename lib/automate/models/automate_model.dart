import 'package:automate_simulator/automate/models/node_model.dart';

class AutomateModel {
  List<NodeModel> nodes = [];
  List<String> alphabet = [];
  NodeModel? startNode;
  List<List<String>> transitionsFunction = [];
}
