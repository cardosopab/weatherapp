import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../my_icons_icons.dart';
import '../../services/temp_unit.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempUnit = ref.watch(tempUnitStateNotifierProvider);
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: IconButton(
            onPressed: () {
              ref.read(tempUnitStateNotifierProvider.notifier).saveTempUnit();
            },
            icon: tempUnit
                ? const Icon(
                    MyIcons.celcius,
                    size: 40,
                  )
                : const Icon(
                    MyIcons.fahrenheit,
                    size: 40,
                  ),
          ),
        ),
      ],
    );
  }
}
