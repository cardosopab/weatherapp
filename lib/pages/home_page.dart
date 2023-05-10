import 'package:flutter/material.dart';
import 'package:weatherapp/utils/ui/home_page/home_body.dart';
import '../contants.dart';
import '../utils/ui/home_page/home_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Constants().homeBackground,
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
