import 'package:flutter/material.dart';
import 'package:weatherapp/utils/ui/home_page/home_body.dart';
import '../utils/ui/home_page/home_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('HomePage Build');
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
        child: const SafeArea(
          child: CustomScrollView(
            slivers: [
              HomeAppBar(),
              HomeBody(),
            ],
          ),
        ),
      ),
    );
  }
}
