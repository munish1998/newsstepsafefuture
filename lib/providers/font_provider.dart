import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontSizeOption { small, medium, large }

class FontProvider extends ChangeNotifier {
  double _fontScale = 1.0;
  FontSizeOption _currentOption = FontSizeOption.medium;

  double get fontScale => _fontScale;
  FontSizeOption get currentOption => _currentOption;

  static const String _key = "font_size_option";

  FontProvider() {
    _loadFontSize();
  }

  void setFontSize(FontSizeOption option) async {
    switch (option) {
      case FontSizeOption.small:
        _fontScale = 0.5;
        break;
      case FontSizeOption.medium:
        _fontScale = 0.7;
        break;
      case FontSizeOption.large:
        _fontScale = 0.9;
        break;
    }
    _currentOption = option;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, option.index);
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index != null &&
        index >= 0 &&
        index < FontSizeOption.values.length) {
      setFontSize(FontSizeOption.values[index]);
    }
  }
} 