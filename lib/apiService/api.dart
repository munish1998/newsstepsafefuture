// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:newsstepsafefuture/model/newModel.dart';

// //import 'new_model.dart'; // Import your model file

// class ApiServices {
//   static const String apiUrl = "https://newstepssafefuture.eu/wp-json/";

//   static Future<NewModel?> fetchData() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         return NewModel.fromJson(jsonData);
        
//       } else {
//         print("Error: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Exception: $e");
//       return null;
//     }
//   }
// }
