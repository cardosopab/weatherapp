import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/location/location.dart';
import '../../../services/geocoding_list.dart';
import '../../../services/location_list.dart';

class HomeGeocodingList extends ConsumerWidget {
  const HomeGeocodingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geocodingList = ref.watch(geoCodingProvider);
    final locationList = ref.watch(locationStateNotifierProvider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: geocodingList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text("${geocodingList[index].name}, ${geocodingList[index].country}, ${geocodingList[index].state ?? ''}"),
          onTap: () async {
            final coordinates = "lat=${geocodingList[index].lat}&lon=${geocodingList[index].lon}";
            Set<Location> locationSet = Set<Location>.from(locationList);
            bool inList = locationSet.any((l) => l.coordinates == coordinates);
            if (inList) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Notice'),
                      content: const Text('That location is already in your list.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            } else {
              final name = geocodingList[index].name;
              ref.watch(locationStateNotifierProvider.notifier).fetchLocation(name, coordinates, ref);
            }
            ref.read(geoCodingProvider.notifier).deleteList();
          },
        );
      },
    );
  }
}
