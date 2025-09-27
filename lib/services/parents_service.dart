import 'package:shared_preferences/shared_preferences.dart';

class ParentsService {
  static const _kPin = 'parent_pin';
  Future<String> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kPin) ?? '1234';
    // TODO (Răzvan): setează un PIN inițial personalizat din Panoul Părinților.
  }

  Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPin, pin);
  }
}
