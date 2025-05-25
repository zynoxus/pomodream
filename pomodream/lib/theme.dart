import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<Color> appThemes = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.pink,
];

class ThemeNotifier extends ChangeNotifier {
  Color _themeColor = Colors.blue;
  Color get themeColor => _themeColor;

  ThemeNotifier() {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('themeIndex') ?? 0;
    _themeColor = appThemes[index];
    notifyListeners();
  }

  void setTheme(Color color) async {
    _themeColor = color;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = appThemes.indexOf(color);
    prefs.setInt('themeIndex', index);
  }
}
