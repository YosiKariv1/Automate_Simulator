import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScffold;
  final Widget tabletScffold;
  final Widget webScffold;

  const ResponsiveLayout(
      {super.key,
      required this.mobileScffold,
      required this.tabletScffold,
      required this.webScffold});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constriants) {
      if (constriants.maxWidth < 600) {
        return mobileScffold;
      } else if (constriants.maxWidth < 1200) {
        return tabletScffold;
      } else {
        return webScffold;
      }
    });
  }
}
