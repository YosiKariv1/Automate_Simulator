import 'package:automate_simulator/mobile/widgets/vertical_slider_mobile.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 135, 203, 46),
      body: Center(
        child: Container(
          width: 400,
          height: 400,
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
                padding: EdgeInsets.only(top: 15.0),
                child: Text("Automate Simulator",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              VerticalSliderMobile(),
            ],
          ),
        ),
      ),
    );
  }
}
