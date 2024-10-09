import 'package:flutter/material.dart';
import 'package:automaton_simulator/classes/dfa_class.dart';
import 'package:automaton_simulator/classes/node_class.dart';
import 'package:automaton_simulator/DFA/simulator/simulator_class.dart';
import 'package:automaton_simulator/DFA/widgets/automaton_widget.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:google_fonts/google_fonts.dart';

class DFAEditorWidget extends StatefulWidget {
  const DFAEditorWidget({super.key});

  @override
  DFAEditorWidgetState createState() => DFAEditorWidgetState();
}

class DFAEditorWidgetState extends State<DFAEditorWidget> {
  late DFA automaton;
  late TransformationController transformationController;
  bool isAnimating = false;
  late Simulator simulator;

  @override
  void initState() {
    super.initState();
    automaton = Provider.of<DFA>(context, listen: false);
    simulator = Simulator(automaton);
    transformationController = TransformationController();
    WidgetsBinding.instance.addPostFrameCallback((_) => centerView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: InteractiveViewer(
        transformationController: transformationController,
        boundaryMargin: const EdgeInsets.all(200),
        minScale: 0.1,
        maxScale: 5.0,
        constrained: false,
        onInteractionEnd: (details) {
          checkBoundaries();
        },
        child: const SizedBox(
          width: 3000,
          height: 3000,
          child: AutomatonWidget(),
        ),
      ),
      bottomNavigationBar: buildButtonBar(),
    );
  }

  Widget buildButtonBar() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton(
            label: 'Add Node',
            color: Colors.deepPurple[700]!,
            icon: Icons.add,
            onPressed: addNode,
          ),
          buildButton(
            label: 'Focus',
            color: Colors.deepPurple[700]!,
            icon: Icons.center_focus_strong_sharp,
            onPressed: focusAutomaton,
          ),
          buildButton(
            label: 'Delete Node',
            color: Colors.deepPurple[900]!,
            icon: Icons.delete,
            onPressed: automaton.removeNode,
          ),
        ],
      ),
    );
  }

  Widget buildButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        minimumSize: const Size(150, 50),
      ),
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          // שימוש בפונט חדש
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void addNode() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localCenter = renderBox.size.center(Offset.zero);
    final Offset globalCenter = renderBox.localToGlobal(localCenter);

    final Matrix4 matrix = transformationController.value;
    final Offset adjustedCenter = Offset(
      (globalCenter.dx - matrix.getTranslation().x) /
          matrix.getMaxScaleOnAxis(),
      (globalCenter.dy - matrix.getTranslation().y) /
          matrix.getMaxScaleOnAxis(),
    );

    automaton.addNode(Node(
      name: 'Q${automaton.nodes.length}',
      position: adjustedCenter,
      isStart: automaton.nodes.isEmpty,
    ));

    centerView();
  }

  void focusAutomaton() {
    if (automaton.nodes.isEmpty) return;
    centerView();
  }

  void centerView() {
    if (automaton.nodes.isEmpty) return;

    Rect boundingBox = calculateBoundingBox();
    animateToArea(boundingBox);
  }

  Rect calculateBoundingBox() {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var node in automaton.nodes) {
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

  void checkBoundaries() {
    final Matrix4 transform = transformationController.value;
    final Offset translation = transform.getTranslation().toOffset();
    final Size size = (context.findRenderObject() as RenderBox).size;

    double minX = size.width - 3000;
    double minY = size.height - 3000;
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
