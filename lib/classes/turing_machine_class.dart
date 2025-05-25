import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:automaton_simulator/classes/node_class.dart';
import 'package:automaton_simulator/classes/rule_class.dart';
import 'package:automaton_simulator/classes/tape_class.dart';
import 'package:automaton_simulator/classes/transition_class.dart';

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
    if (kDebugMode) {
      print(
          "Rule added: ${rule.read} -> ${rule.write}, direction: ${rule.direction}");
    }
    addNodeForRule(rule);
    notifyListeners();
  }

  void deleteRule(int index) {
    if (index >= 0 && index < rules.length) {
      rules.removeAt(index);
      Node nodeToRemove = nodes.removeAt(index);
      transitions
          .removeWhere((t) => t.from == nodeToRemove || t.to == nodeToRemove);
      if (kDebugMode) {
        print(
            "Rule at index $index deleted, associated node and transitions removed.");
      }
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
    if (kDebugMode) {
      print("Head Position = $headPosition");
    }
    notifyListeners();
  }

  void setHeadPosition(int position) {
    if (position >= 0 && position < cells.length) {
      cells[headPosition].isHead = false; // בטל את הראש הקודם
      headPosition = position;
      cells[headPosition].isHead = true; // הגדר את המיקום החדש כראש
      if (kDebugMode) {
        print("Head Position set to = $headPosition");
      }
      notifyListeners();
    }
  }

  void updateTapeContent(int index, String content) {
    if (index >= 0 && index < cells.length) {
      cells[index].write(content);
      if (kDebugMode) {
        print("Cell $index = $content");
      }
    }
    notifyListeners();
  }

  void resetTape() {
    for (var cell in cells) {
      cell.clear();
    }
    if (kDebugMode) {
      print("Tape reset.");
    }
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
    if (kDebugMode) {
      print(
          "Node added for rule ID: ${rule.id}, Node Position: ($xPosition, $yPosition)");
    }
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
      if (kDebugMode) {
        print(
            "Transition added: from Node ${from.name} to Node ${to.name}, Read: ${rule.read}, Write: ${rule.write}, Direction: ${rule.direction}");
      }
      notifyListeners();
    }
  }
}
