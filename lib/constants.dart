import 'package:flutter/material.dart';

var myDefaultBackgroundColor1 = const Color.fromARGB(255, 235, 208, 119);
var myDefaultBackgroundColor2 = const Color.fromARGB(255, 255, 202, 27);

final List<Color> imgList = [
  const Color.fromARGB(255, 233, 5, 5),
  const Color.fromARGB(255, 14, 17, 212),
  const Color.fromARGB(255, 29, 228, 11),
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Container(
                  color: item,
                  width: 1000.0,
                  height: double.infinity, // or specify a height
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      'No. ${imgList.indexOf(item)} image',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ))
    .toList();
