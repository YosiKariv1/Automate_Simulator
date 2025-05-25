import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class PanelContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? icon;
  final Key? containerKey;
  final double? height;
  final EdgeInsets margin;
  final bool scrollable;

  const PanelContainer({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.containerKey,
    this.height,
    this.margin = const EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
    this.scrollable = false,
    required EdgeInsets padding,
  });

  @override
  Widget build(BuildContext context) {
    final panelContent = scrollable
        ? Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: child,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: child,
          );

    return Container(
      key: containerKey,
      margin: margin,
      constraints: height != null
          ? BoxConstraints(minHeight: height!, maxHeight: height!)
          : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.0),
        border: Border.all(color: Colors.deepPurple.shade500, width: 4.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15.0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (icon != null) icon!,
              ],
            ),
          ),
          panelContent,
        ],
      ),
    );
  }
}
