import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlassMorphism extends ConsumerWidget {
  final double blur;
  final double opacity;
  final bool? isDaytime;
  final Widget child;
  const GlassMorphism({
    Key? key,
    required this.blur,
    required this.opacity,
    required this.child,
    required this.isDaytime,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: isDaytime == true
                ? Colors.blue.withOpacity(opacity)
                // : Colors.cyan[800]?.withOpacity(opacity),
                : Colors.blue[800]?.withOpacity(opacity),
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
