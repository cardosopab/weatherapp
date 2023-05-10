import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:weatherapp/utils/services/location_object.dart';

import '../../../../models/location/location.dart';
import '../../../../pages/location_page.dart';
import '../../../services/location_list.dart';
import 'home_tile.dart';

class HomeLocationList extends ConsumerWidget {
  const HomeLocationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationFuture = ref.watch(locationFutureProvider);
    return locationFuture.when(
      data: (locationFuture) {
        List<Location> locationList = locationFuture.map((e) => e).toList();
        return ListView.builder(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: locationList.length,
          itemBuilder: (context, index) {
            final location = locationList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (() {
                  ref.read(locationObjectStateProvider.notifier).saveLocation(location);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const LocationPage()),
                    ),
                  );
                }),
                child: Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          ref.read(locationStateNotifierProvider.notifier).removeAt(index);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: HomeTile(location: location),
                ),
              ),
            );
          },
        );
      },
      error: (e, s) => Center(
        child: Text(
          e.toString(),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
