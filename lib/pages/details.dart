import 'package:flutter/material.dart';
import 'package:national_weather/models/sharedpreferences/sharedPref.dart';

class DetailsPage extends StatelessWidget {
  final SharedPref sharedPref;
  const DetailsPage({Key? key, required this.sharedPref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    sharedPref.icon.toString(),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            sharedPref.short_name.toString(),
                          ),
                          Text(sharedPref.shortForecast.toString())
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${sharedPref.temperature}°',
                          ),
                          Text(sharedPref.forecastHourlyUrl.toString())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
