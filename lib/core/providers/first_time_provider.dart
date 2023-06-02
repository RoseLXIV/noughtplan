import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firstTimeProvider = StateNotifierProvider<FirstTimeNotifier, bool>((ref) {
  return FirstTimeNotifier();
});

class FirstTimeNotifier extends StateNotifier<bool> {
  FirstTimeNotifier() : super(true) {
    _checkIfFirstTime();
  }

  Future<void> _checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _firstTime = prefs.getBool('first_time') ?? true;

    if (_firstTime) {
      await prefs.setBool('first_time', false);
    }
    state = _firstTime;
  }

  void hideCoachMark() {
    state = false;
  }
}
