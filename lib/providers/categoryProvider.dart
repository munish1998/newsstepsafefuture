// import 'package:flutter/material.dart';
// import 'package:newsstepsafefuture/apiService/wordpressService.dart';
// import 'package:newsstepsafefuture/model/categoriesModel.dart';


// class CategoriesProvider with ChangeNotifier {
//   List<CategoriesModel> _categories = [];
//   bool _isLoading = false;

//   List<CategoriesModel> get categories => _categories;
//   bool get isLoading => _isLoading;

//   Future<void> fetchCategories() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       _categories = await WordPressService().fetchCategories();
//     } catch (e) {
//       print('Error fetching categories: $e');
//     }
//     _isLoading = false;
//     notifyListeners();
//   }
// }
