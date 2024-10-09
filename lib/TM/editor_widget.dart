import 'package:flutter/material.dart';
import 'package:automaton_simulator/TM/widgets/turing_machine_widget.dart';
import 'package:automaton_simulator/classes/turing_machine_class.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class TmEditorWidget extends StatefulWidget {
  final TuringMachine turingMachine;

  const TmEditorWidget({super.key, required this.turingMachine});

  @override
  TmEditorWidgetState createState() => TmEditorWidgetState();
}

class TmEditorWidgetState extends State<TmEditorWidget> {
  late TransformationController transformationController;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    transformationController = TransformationController();
    WidgetsBinding.instance.addPostFrameCallback((_) => centerView());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10.0),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            transformationController: transformationController,
            boundaryMargin: const EdgeInsets.all(200),
            minScale: 0.1,
            maxScale: 5.0,
            constrained: false,
            onInteractionEnd: (details) {
              checkBoundaries(constraints.maxWidth, constraints.maxHeight);
            },
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: const TuringMachineWidget(),
            ),
          );
        },
      ),
    );
  }

  void centerView() {
    if (widget.turingMachine.rules.isEmpty) return;

    Rect boundingBox = calculateBoundingBox();
    animateToArea(boundingBox);
  }

  Rect calculateBoundingBox() {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var node in widget.turingMachine.nodes) {
      minX = minX < node.position.dx ? minX : node.position.dx;
      minY = minY < node.position.dy ? minY : node.position.dy;
      maxX = maxX > node.position.dx ? maxX : node.position.dx;
      maxY = maxY > node.position.dy ? maxY : node.position.dy;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  void animateToArea(Rect area) {
    final Size size = (context.findRenderObject() as RenderBox).size;

    double scaleX = size.width / (area.width + 100);
    double scaleY = size.height / (area.height + 100);
    double scale = scaleX < scaleY ? scaleX : scaleY;

    scale = scale.clamp(0.1, 1.0);

    double x = -area.center.dx * scale + size.width / 2;
    double y = -area.center.dy * scale + size.height / 2;

    final Matrix4 newTransform = Matrix4.identity()
      ..translate(x, y)
      ..scale(scale);

    animateTransform(newTransform);
  }

  void checkBoundaries(double maxWidth, double maxHeight) {
    final Matrix4 transform = transformationController.value;
    final Offset translation = transform.getTranslation().toOffset();

    double minX = maxWidth - 3000;
    double minY = maxHeight - 3000;
    double maxX = 0.0;
    double maxY = 0.0;

    double clampedX = translation.dx.clamp(minX, maxX);
    double clampedY = translation.dy.clamp(minY, maxY);

    if (clampedX != translation.dx || clampedY != translation.dy) {
      transformationController.value = Matrix4.identity()
        ..translate(clampedX, clampedY)
        ..scale(transform.getMaxScaleOnAxis());
    }
  }

  void animateTransform(Matrix4 newTransform) {
    if (isAnimating) return;
    isAnimating = true;

    Animation<Matrix4> animation = Matrix4Tween(
      begin: transformationController.value,
      end: newTransform,
    ).animate(CurvedAnimation(
      parent: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 500),
      )..forward(),
      curve: Curves.easeInOut,
    ));

    animation.addListener(() {
      transformationController.value = animation.value;
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isAnimating = false;
      }
    });
  }
}

extension on Vector3 {
  Offset toOffset() => Offset(x, y);
}
