import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          );
  }
}