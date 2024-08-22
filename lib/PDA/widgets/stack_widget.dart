import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/classes/pda_class.dart';

class StackWidget extends StatelessWidget {
  const StackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PDA>(
      builder: (context, pda, child) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Stack',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
              const SizedBox(height: 10),
              ...pda.stack.reversed.map((item) {
                return AnimatedStackItem(
                  item: item,
                  isTop: pda.stack.last == item,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedStackItem extends StatelessWidget {
  final String item;
  final bool isTop;

  const AnimatedStackItem({
    Key? key,
    required this.item,
    required this.isTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isTop ? Colors.blueAccent : Colors.deepPurple[100],
        border: Border.all(color: Colors.deepPurple, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          item,
          style: TextStyle(
            fontSize: 18,
            color: isTop ? Colors.white : Colors.deepPurple[900],
          ),
        ),
      ),
    );
  }
}
