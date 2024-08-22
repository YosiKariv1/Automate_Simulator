import 'package:flutter/material.dart';
import 'package:myapp/TM/simulator/tm_algorithm.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/rule_class.dart';
import 'package:myapp/classes/tape_class.dart';
import 'package:myapp/classes/transition_class.dart';

class TuringMachine extends ChangeNotifier {
  List<Rule> rules;
  List<Node> nodes;
  List<Transition> transitions;
  List<TapeCell> cells;
  int headPosition;

  TuringMachine({int tapeLength = 25})
      : rules = [],
        nodes = [],
        transitions = [],
        cells = List.generate(tapeLength, (_) => TapeCell()),
        headPosition = 0 {
    cells[headPosition].isHead = true;
  }

  List<Node> getNodes() => nodes;

  void addRule(Rule rule) {
    rules.add(rule);
    print(
        "Rule added: ${rule.read} -> ${rule.write}, direction: ${rule.direction}");
    addNodeForRule(rule);
    notifyListeners();
  }

  void deleteRule(int index) {
    if (index >= 0 && index < rules.length) {
      rules.removeAt(index);
      Node nodeToRemove = nodes.removeAt(index);
      transitions
          .removeWhere((t) => t.from == nodeToRemove || t.to == nodeToRemove);
      print(
          "Rule at index $index deleted, associated node and transitions removed.");
      notifyListeners();
    }
  }

  void executeRule(Rule rule) {
    updateTapeContent(headPosition, rule.write);
    moveHead(rule.direction);

    notifyListeners();
  }

  void moveHead(String direction) {
    cells[headPosition].isHead = false;

    if (direction.toLowerCase() == 'left' && headPosition > 0) {
      headPosition--;
    } else if (direction.toLowerCase() == 'right' &&
        headPosition < cells.length - 1) {
      headPosition++;
    }

    cells[headPosition].isHead = true;
    print("Head Position = $headPosition");
    notifyListeners();
  }

  void setHeadPosition(int position) {
    if (position >= 0 && position < cells.length) {
      cells[headPosition].isHead = false; // בטל את הראש הקודם
      headPosition = position;
      cells[headPosition].isHead = true; // הגדר את המיקום החדש כראש
      print("Head Position set to = $headPosition");
      notifyListeners();
    }
  }

  void updateTapeContent(int index, String content) {
    if (index >= 0 && index < cells.length) {
      cells[index].write(content);
      print("Cell $index = $content");
    }
    notifyListeners();
  }

  void resetTape() {
    for (var cell in cells) {
      cell.clear();
    }
    print("Tape reset.");
    notifyListeners();
  }

  void addNodeForRule(Rule rule) {
    double xPosition = 500.0 + 100.0 * rules.length;
    double yPosition = 200.0;

    Node node = Node(
      name: '${rule.id}',
      position: Offset(xPosition, yPosition),
      isStart: rules.isEmpty,
    );
    nodes.add(node);
    print(
        "Node added for rule ID: ${rule.id}, Node Position: (${xPosition}, ${yPosition})");
    notifyListeners();
  }

  void addTransitionForRule(Node from, Node to, Rule rule) {
    if (rules.isNotEmpty) {
      Transition transition = Transition(
          from: from,
          to: to,
          read: rule.read,
          write: rule.write,
          direction: rule.direction,
          symbol: {});
      transitions.add(transition);
      print(
          "Transition added: from Node ${from.name} to Node ${to.name}, Read: ${rule.read}, Write: ${rule.write}, Direction: ${rule.direction}");
      notifyListeners();
    }
  }
}
