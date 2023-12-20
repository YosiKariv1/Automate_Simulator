import 'package:automate_simulator/responsive/resoibsive_layout.dart';
import 'package:automate_simulator/responsive/mobile_scaffold.dart';
import 'package:automate_simulator/responsive/tablet_scaffold.dart';
import 'package:automate_simulator/responsive/web_scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResponsiveLayout(
        mobileScffold: MobileScaffold(),
        tabletScffold: TabletScaffold(),
        webScffold: WebScaffold(),
      ),
    );
  }
}
