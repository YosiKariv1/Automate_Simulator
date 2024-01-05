import 'package:flutter/material.dart';
import 'package:automate_simulator/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'automate_editor.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 45.0),
                child: Text("Automate Simulator",
                    style:
                        TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
              ),
              const VerticalSliderDemo(),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AutomateEditorWeb(),
                      ),
                    );
                  },
                  child: const Text("click me")),
            ],
          ),
        ),
      ),
    );
  }
}

class VerticalSliderDemo extends StatelessWidget {
  const VerticalSliderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // specify height
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          autoPlay: true,
        ),
        items: imageSliders,
      ),
    );
  }
}
