import 'dart:ui';
import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  // final double blur;
  // final double opacity;
  final bool? isDaytime;
  final Widget child;
  const GlassMorphism({
    Key? key,
    // required this.blur,
    // required this.opacity,
    required this.child,
    required this.isDaytime,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double blur = 35;
    double opacity = .5;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: isDaytime == true //
                ? Colors.blue[500]?.withOpacity(opacity) //
                : Colors.blue[300]?.withOpacity(opacity), //
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(
              width: 1.5,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
