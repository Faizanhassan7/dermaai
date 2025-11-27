import 'package:flutter/material.dart';

class CustomGradientContainer extends StatelessWidget {
  final double widthFactor;
  final double heightFactor;
  final Widget? child;
  final List<Color>? colors; // 🔹 custom gradient colors

  const CustomGradientContainer({
    super.key,
    this.widthFactor = 1,
    this.heightFactor = 1,
    this.child,
    this.colors, // 🔹 optional custom gradient
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * widthFactor;
    final height = size.height * heightFactor;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ??
              const [
                Color(0xFFE5E5F1),
                Color(0xFF042FFF),
                Color(0xFF7226FF),
              ],
        ),
      ),
      child: child,
    );
  }
}
