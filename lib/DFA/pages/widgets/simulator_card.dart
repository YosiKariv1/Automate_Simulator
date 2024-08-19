import 'package:flutter/material.dart';

class SimulatorCard extends StatefulWidget {
  final String title;
  final IconData placeholderIcon;
  final VoidCallback onTap;

  const SimulatorCard({
    required this.title,
    required this.placeholderIcon,
    required this.onTap,
    super.key,
  });

  @override
  SimulatorCardState createState() => SimulatorCardState();
}

class SimulatorCardState extends State<SimulatorCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isHovered ? 20 : 10,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 220,
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isHovered ? Colors.blueGrey[200] : Colors.white,
              gradient: isHovered
                  ? const LinearGradient(
                      colors: [Colors.blueGrey, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Colors.white, Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.placeholderIcon,
                    size: 80, color: Colors.blueGrey[800]),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool hovering) {
    setState(() {
      isHovered = hovering;
    });
  }
}
