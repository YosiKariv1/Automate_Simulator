import 'package:flutter/material.dart';

class AnimatedBorder extends StatefulWidget {
  final bool isSimulating;

  const AnimatedBorder({super.key, required this.isSimulating});

  @override
  AnimatedBorderState createState() => AnimatedBorderState();
}

class AnimatedBorderState extends State<AnimatedBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: widget.isSimulating
          ? AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.redAccent
                          .withOpacity(0.5 + 0.5 * _animation.value),
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                );
              },
            )
          : const SizedBox.expand(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
