import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:national_weather/Widgets/isDaytime.dart';

class GlassMorphism extends ConsumerWidget {
  final double blur;
  final double opacity;
  final Widget child;
  const GlassMorphism({
    Key? key,
    required this.blur,
    required this.opacity,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDaytime = ref.watch(isDaytimeProvider);
    print('Glass: $isDaytime');
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.blue.withOpacity(opacity),
            // color: Colors.black.withOpacity(opacity),
            color: isDaytime == true
                ? Colors.blue.withOpacity(opacity)
                : Colors.black.withOpacity(opacity),
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
