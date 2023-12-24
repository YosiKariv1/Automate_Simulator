import 'package:flutter/material.dart';

var myDefaultBackgroundColor1 = const Color.fromARGB(255, 235, 208, 119);
var myDefaultBackgroundColor2 = const Color.fromARGB(255, 255, 202, 27);

final List<Color> imgList = [
  const Color.fromARGB(255, 233, 5, 5),
  const Color.fromARGB(255, 14, 17, 212),
  const Color.fromARGB(255, 29, 228, 11),
];

final List<Widget> imageSliders = imgList
    .map((item) => ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Stack(
            children: <Widget>[
              Container(
                color: item, // or specify a height
              ),
            ],
          ),
        ))
    .toList();
