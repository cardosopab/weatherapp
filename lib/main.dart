import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/homepage.dart';

void main() async {
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
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const HomePage(title: 'National Weather'),
    );
  }
}
