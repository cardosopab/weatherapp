import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

import 'reverse_string.dart';

String hourlyTime(int dt, String timezone) {
  DateTime local = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
  final locationTime = TZDateTime.from(local, getLocation(timezone));
  String? result;
//
  var reversed = reverseStringUsingSplit(locationTime.toString());
  if (reversed.contains("+")) {
    var index = reversed.indexOf("+");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
    //
  } else if (reversed.contains("-")) {
    var index = reversed.indexOf("-");
    var string = reversed.substring(index + 1, reversed.length);
    result = reverseStringUsingSplit(string);
  }
//
  var locationFormat = DateFormat("h a").format(DateTime.parse(result!));
//
  return locationFormat;
}
//
