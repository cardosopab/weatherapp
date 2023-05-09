import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../models/location/location.dart';
import '../../../pages/location_page.dart';
import '../../../widgets/glass.dart';
import '../../functions/format_unit.dart';
import '../../services/location_list.dart';
import '../../services/temp_unit.dart';

class HomeLocationList extends ConsumerWidget {
  const HomeLocationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationFuture = ref.watch(locationFutureProvider);
    final tempUnit = ref.watch(tempUnitStateNotifierProvider);
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => LocationPage(location: location)),
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
                        child: GlassMorphism(
                          isDaytime: location.isDaytime,
                          blur: 30,
                          opacity: .5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: Text(
                                        location.name.toString(),
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                    ),
                                    Text(location.main.toString(), style: const TextStyle(fontSize: 20)),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child: Text(
                                      '${formatUnit(location.temp!, ref)}°${tempUnit ? 'F' : "C"}',
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image: AssetImage("assets/images/${location.icon}.png"), fit: BoxFit.none),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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