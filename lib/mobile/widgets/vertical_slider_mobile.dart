import 'package:automate_simulator/constants.dart';
import 'package:automate_simulator/mobile/page1.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class VerticalSliderMobile extends StatelessWidget {
  const VerticalSliderMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = [
      GestureDetector(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SimpleInputPage())),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Container(color: imgList[0]),
        ),
      ),
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: Container(color: imgList[1]),
      ),
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: Container(color: imgList[2]),
      ),
    ];

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
