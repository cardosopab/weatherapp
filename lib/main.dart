import 'dart:ui';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/browser.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/homepage.dart';

// var unitBool = true;
void main() async {
  tz.initializeTimeZones();
  await dotenv.load(fileName: "dotenv");

  if (kIsWeb) {
    // tz.initializeTimeZones();

    runApp(const ProviderScope(
        child:
            Center(child: SizedBox(width: 400, height: 800, child: MyApp()))));
  } else {
    // tz.initializeTimeZones();
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'National Weather',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        // textTheme: ThemeData.dark().textTheme.copyWith(
        //       bodyText1: const TextStyle(color: Colors.white),
        //       bodyText2: const TextStyle(color: Colors.white),
        //     ),
      ),
      home: const HomePage(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
