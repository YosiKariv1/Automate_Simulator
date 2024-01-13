import 'package:automate_simulator/web/widgets/vertical_slider_web.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 135, 203, 46),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 205, 240, 159),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black45, blurRadius: 15.0, spreadRadius: 1.0),
              ]),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 45.0),
                child: Text("Automate Simulator",
                    style:
                        TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
              ),
              VerticalSliderWeb(),
            ],
          ),
        ),
      ),
    );
  }
}
