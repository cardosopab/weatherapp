import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempUnitNotifier extends StateNotifier<bool> {
  late final SharedPreferences _prefs;
  TempUnitNotifier(bool tempUnit) : super(tempUnit) {
    _loadTempUnit();
  }

  void saveTempUnit() async {
    state = !state;
    await _prefs.setBool(_kTempUnitKey, state);
  }

  static const _kTempUnitKey = 'tempUnit';

  Future<void> _loadTempUnit() async {
    _prefs = await SharedPreferences.getInstance();
    final tempUnit = _prefs.getBool(_kTempUnitKey);
    if (tempUnit != null) {
      state = tempUnit;
    } else {
      _prefs.setBool(_kTempUnitKey, true);
    }
  }
}

final tempUnitStateNotifierProvider = StateNotifierProvider<TempUnitNotifier, bool>((ref) {
  return TempUnitNotifier(true);
});
