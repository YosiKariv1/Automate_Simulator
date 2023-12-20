import 'package:flutter/material.dart';
import 'package:automate_simulator/constants.dart';
import 'automate/automate_editor.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade500,
                    offset: const Offset(5.0, 5.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
                const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-0.4, -0.4),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Automate Simulator", style: TextStyle(fontSize: 30)),
              const VerticalSliderDemo(),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const AutomateEditor(), // replace with your actual editor widget
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
