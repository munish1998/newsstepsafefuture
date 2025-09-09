// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:newsstepsafefuture/model/categoriesModel.dart';

// class WordPressService {
//   static const String baseUrl =
//       'https://webpristine.com/nssf/wp-json/wp/v2/posts?categories=4';

//   Future<List<CategoriesModel>> fetchCategories() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       log('category fetch response===>>>>${response.body}');
//       return jsonData.map((json) => CategoriesModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }
// }
