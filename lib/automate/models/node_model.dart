import 'package:flutter/material.dart';

class NodeModel {
  String name = '';
  Offset location;
  Map<String, NodeModel>? next;
  bool ifFinal;

  NodeModel(
      {required this.name,
      required this.location,
      required this.next,
      required this.ifFinal});

  Offset rightCirclePosition() {
    return Offset(
      location.dx + 50,
      location.dy + 20,
    );
  }

  Offset leftCirclePosition() {
    return Offset(
      location.dx - 10,
      location.dy + 20,
    );
  }
}
