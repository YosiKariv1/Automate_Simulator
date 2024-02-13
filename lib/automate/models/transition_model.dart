import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/node_model.dart';

class TransitionModel {
  Offset start;
  Offset end;
  NodeModel? node;
  NodeModel? target;
  Rect? textRect;
  String alphabet;

  TransitionModel(this.start, this.end,
      {this.node, this.target, this.textRect, this.alphabet = ''});
}
