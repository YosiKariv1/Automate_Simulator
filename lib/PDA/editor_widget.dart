import 'package:flutter/material.dart';
import 'package:myapp/PDA/widgets/pda_widget.dart';
import 'package:myapp/classes/node_class.dart';
import 'package:myapp/classes/pda_class.dart';
import 'package:provider/provider.dart';

class PDAEditorWidget extends StatefulWidget {
  const PDAEditorWidget({super.key});

  @override
  PDAEditorWidgetState createState() => PDAEditorWidgetState();
}

class PDAEditorWidgetState extends State<PDAEditorWidget> {
  late PDA automaton;
  bool isAnimating = false;
  late TransformationController transformationController;

  @override
  void initState() {
    super.initState();
    automaton = Provider.of<PDA>(context, listen: false);
    transformationController = TransformationController();
    WidgetsBinding.instance.addPostFrameCallback((_) => centerView());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(200),
            minScale: 0.1,
            maxScale: 5.0,
            constrained: false,
            child: const SizedBox(
              width: 3000,
              height: 3000,
              child: PDAWidget(),
            ),
          ),
        ),
        buildButtonBar(),
      ],
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

  void addNode() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localCenter = renderBox.size.center(Offset.zero);
    final Offset globalCenter = renderBox.localToGlobal(localCenter);

    automaton.addNode(Node(
      name: 'Q${automaton.nodes.length}',
      position: globalCenter,
      isStart: automaton.nodes.isEmpty,
    ));
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
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
