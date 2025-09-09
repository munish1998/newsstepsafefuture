import 'dart:convert';
import 'dart:developer';
//import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:newsstepsafefuture/model/fetchModel.dart';

class ApiService {
  static const String baseUrl =
      'https://webpristine.com/nssf/wp-json/wp/v2/pages';

  Future<List<FetchModel>> fetchPages() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        log('fetch data response =====>>>>${response.body}');
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => FetchModel.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
}
