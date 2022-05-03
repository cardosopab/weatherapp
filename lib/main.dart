import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/homepage.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  if (kIsWeb) {
    runApp(const ProviderScope(
        child:
            Center(child: SizedBox(width: 400, height: 800, child: MyApp()))));
  } else {
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
      theme: ThemeData.dark(),
      // theme: ThemeData(
      //   textTheme: ThemeData.dark().textTheme.copyWith(
      //         bodyText1: const TextStyle(color: Colors.white),
      //         bodyText2: const TextStyle(color: Colors.white),
      //       ),
      // ),
      // darkTheme: ThemeData.dark(),
      home: const HomePage(title: 'National Weather'),
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
