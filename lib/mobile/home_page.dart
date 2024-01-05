import 'package:flutter/material.dart';
import 'package:automate_simulator/constants.dart';
import 'automate_editor.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text("Automate Simulator",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              const VerticalSliderDemo(),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AutomateEditorMobile(),
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
      height: 250, // specify height
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
