import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklyHeader extends ConsumerWidget {
  const WeeklyHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 8, 8),
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  WidgetSpan(
                    child: Icon(
                      Icons.calendar_month_outlined,
                      size: 15,
                    ),
                  ),
                  TextSpan(text: " 7-DAY FORECAST"),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            SizedBox(
              width: 35,
              child: Text(""),
            ),
            SizedBox(
              width: 35,
              child: Text(""),
            ),
            SizedBox(
              width: 35,
              child: Text(
                "MORN",
                style: TextStyle(fontSize: 10),
              ),
            ),
            SizedBox(
              width: 35,
              child: Text(
                "DAY",
                style: TextStyle(fontSize: 10),
              ),
            ),
            SizedBox(
              width: 35,
              child: Text(
                "EVE",
                style: TextStyle(fontSize: 10),
              ),
            ),
            SizedBox(
              width: 35,
              child: Text(
                "NIGHT",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
