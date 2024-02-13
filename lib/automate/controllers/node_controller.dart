import 'package:flutter/material.dart';
import 'package:automate_simulator/automate/models/node_model.dart';
import 'package:automate_simulator/automate/widgets/node_widget.dart';

class NodeController {
  late NodeModel model;
  late NodeWidget widget;
  ValueNotifier<Offset> positionNotifier;

  NodeController({
    required String name,
    bool ifFinal = false,
    Map<String, NodeModel>? next,
    required Function onUpdatePosition,
    required Function onStartTransition,
    required Function onUpdateTransition,
    required Function onEndTransition,
  }) : positionNotifier = ValueNotifier<Offset>(const Offset(100, 100)) {
    model = NodeModel(name: name);
    widget = NodeWidget(
      key: UniqueKey(),
      node: model,
      positionNotifier: positionNotifier,
      updatePosition: onUpdatePosition,
      startTransition: onStartTransition,
      updateTransition: onUpdateTransition,
      endTransition: onEndTransition,
    );
  }

  Offset get rightCirclePosition =>
      Offset(positionNotifier.value.dx + 50, positionNotifier.value.dy + 20);

  Offset get leftCirclePosition =>
      Offset(positionNotifier.value.dx - 10, positionNotifier.value.dy + 20);
}
