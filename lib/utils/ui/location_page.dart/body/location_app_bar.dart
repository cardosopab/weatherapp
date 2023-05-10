import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/location/location.dart';
import '../../../services/location_list.dart';
import '../../../services/location_object.dart';

class LocationAppBar extends ConsumerWidget {
  const LocationAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Location location = ref.watch(locationObjectStateProvider);
    final locationList = ref.watch(locationStateNotifierProvider);
    final index = locationList.indexOf(location);
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(onPressed: (() => Navigator.pop(context)), icon: const Icon(Icons.arrow_back_ios)),
      actions: [
        IconButton(
            onPressed: (() {
              ref.read(locationStateNotifierProvider.notifier).removeAt(index);
              Navigator.pop(context);
            }),
            icon: const Icon(Icons.cancel))
      ],
    );
  }
}
