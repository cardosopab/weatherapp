import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weatherapp/models/location/location.dart';
import 'package:weatherapp/pages/location_page.dart';
import 'package:weatherapp/utils/services/geocoding_list.dart';
import 'package:weatherapp/utils/services/location_list.dart';
import 'package:weatherapp/utils/services/temp_unit.dart';

import '../my_icons_icons.dart';
import '../utils/functions/format_unit.dart';
import '../widgets/glass.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Timer? _debounce;

  final TextEditingController _addressController = TextEditingController();

  void clear() {
    _addressController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final geocodingList = ref.watch(geoCodingProvider);
    final locationFuture = ref.watch(locationFutureProvider);
    final tempUnit = ref.watch(tempUnitStateNotifierProvider);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF146ac9),
              Color(0xFF3814d8),
              Color(0xFF5b0dae),
              Color(0xFF0c9bb0),
              Color(0xFF33bdf2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
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
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Open Weather Maps",
                            style: TextStyle(fontSize: 30),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          suffixIcon: Visibility(
                            visible: _addressController.text.isNotEmpty || geocodingList.isNotEmpty,
                            child: IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                clear();
                                ref.read(geoCodingProvider.notifier).deleteList();
                              },
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          hintText: 'Search by city.',
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        controller: _addressController,
                        onSubmitted: (_addressController) async {
                          if (_addressController.isNotEmpty) {
                            ref.watch(geoCodingProvider.notifier).fetchGeocode(_addressController);
                            clear();
                          }
                        },
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce = Timer(const Duration(milliseconds: 1000), () {
                            if (value.isNotEmpty) {
                            } else {
                              clear();
                            }
                          });
                        },
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: geocodingList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            title: Text("${geocodingList[index].name}, ${geocodingList[index].country}, ${geocodingList[index].state ?? ''}"),
                            onTap: () async {
                              final coordinates = "lat=${geocodingList[index].lat}&lon=${geocodingList[index].lon}";
                              final name = geocodingList[index].name;
                              ref.watch(locationStateNotifierProvider.notifier).fetchLocation(name, coordinates, ref);
                              ref.read(geoCodingProvider.notifier).deleteList();
                            });
                      },
                    ),
                    locationFuture.when(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Learn more about the ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'Open Weather Maps API',
                                    style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Colors.white),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        var url = 'https://openweathermap.org/api';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Cannot load Url';
                                        }
                                      },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    'assets/images/logo_white_cropped.png',
                                    fit: BoxFit.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
