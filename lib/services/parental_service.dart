import 'package:shared_preferences/shared_preferences.dart';

class ParentalService {
  static const _kPinKey = 'parent_pin';
  SharedPreferences? _prefs;
  String _pin = '1234';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _pin = _prefs?.getString(_kPinKey) ?? '1234';
  }

  Future<void> setPin(String pin) async {
    _pin = pin;
    await _prefs?.setString(_kPinKey, pin);
  }

  bool verify(String pin) => pin == _pin;
}
