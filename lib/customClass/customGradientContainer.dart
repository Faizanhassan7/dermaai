// custom_gradient_container.dart
import 'package:flutter/material.dart';

class CustomGradientContainer extends StatelessWidget {
  final double widthFactor;
  final double heightFactor;
  final Widget? child;

  const CustomGradientContainer({
    super.key,
    this.widthFactor = 1,  // 1 = full width
    this.heightFactor = 1, // 1 = full height
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * widthFactor;
    final height = size.height * heightFactor;

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE5F1),
            Color(0xFF042FF),
            Color(0xff7226FF)
          ],
        ),
       // borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: child,
    );
  }
}
