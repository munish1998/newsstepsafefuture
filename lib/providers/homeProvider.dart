// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:newsstepsafefuture/model/homeModel.dart';


// class PageProvider with ChangeNotifier {
//   List<PageModel> _pages = [];
//   bool _isLoading = false;

//   List<PageModel> get pages => _pages;
//   bool get isLoading => _isLoading;

//   Future<void> fetchPage() async {
//   _isLoading = true;
//   notifyListeners();

//   try {
//     final response = await http.get(Uri.parse('https://webpristine.com/nssf/wp-json/wp/v2/pages?slug=homepage'));

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       log("API Response: ${jsonEncode(data)}"); // Print full response for debugging

//       _pages = data.map((json) => PageModel.fromJson(json)).toList();
      
//       // Log each extracted image URL
//       for (var page in _pages) {
//         log("Title: ${page.title}");
//         log("Image URL: ${page.content}");
//       }

//     } else {
//       throw Exception("Failed to load pages");
//     }
//   } catch (error) {
//     log("Error fetching pages: $error");
//   }

//   _isLoading = false;
//   notifyListeners();
// }



// }
