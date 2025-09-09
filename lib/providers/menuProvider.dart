import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuProvider extends ChangeNotifier {
  Map<String, dynamic> _menuData = {}; 
  bool _isLoading = false;
  String? _error; // Store error messages

  Map<String, dynamic> get menuData => _menuData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMenu() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://webpristine.com/nssf/wp-json/menus/v1/menus/homepage-menu'),
      );

      if (response.statusCode == 200) {
        _menuData = jsonDecode(response.body);
        log('Menu Data:======>>>>>>> $_menuData'); // Debugging
      } else {
        _error = 'Failed to load menu: ${response.statusCode}';
        print(_error);
      }
    } catch (e) {
      _error = 'Error fetching menu: $e';
      print(_error);
    }

    _isLoading = false;
    notifyListeners();
  }
}
