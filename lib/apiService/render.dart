// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:html/parser.dart' as htmlParser;
// import 'package:http/http.dart' as http;
// import 'package:flutter_screenutil/flutter_screenutil.dart';


// class WebPageScreen extends StatefulWidget {
//   @override
//   _WebPageScreenState createState() => _WebPageScreenState();
// }

// class _WebPageScreenState extends State< WebPageScreen> {
//   String pageTitle = "";
//   String introDescription = "";
//   String webPortalHeading = "";
//   String webPortalContent = "";
//   List<Map<String, String>> titleImageList = [];
//   final String baseUrl = "https://webpristine.com";

//   @override
//   void initState() {
//     super.initState();
//     fetchPageData();
//   }

//   Future<void> fetchPageData() async {
//     final response = await http.get(Uri.parse('https://webpristine.com/nssf/wp-json/wp/v2/pages/18'));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       final document = htmlParser.parse(data['content']['rendered']);

//       // Extract Main Title (h1)
//       final h1Tag = document.querySelector('h1');
//       String extractedTitle = h1Tag != null ? h1Tag.text.trim() : "";

//       // Extract Introductory Description
//       final introParagraph = document.querySelector('div > p');
//       String introText = introParagraph != null ? introParagraph.text.trim() : "";

//       // Extract List Items (Modules with Image and Title)
//       List<Map<String, String>> fetchedList = [];
//       final listItems = document.querySelectorAll('ul > li');

//       for (var item in listItems) {
//         final imgTag = item.querySelector('img');
//         final titleTag = item.querySelector('h3');

//         if (imgTag != null && titleTag != null) {
//           String imageUrl = imgTag.attributes['src'] ?? '';
//           if (imageUrl.startsWith("/")) {
//             imageUrl = "$baseUrl$imageUrl"; // Convert relative path to full URL
//           }

//           fetchedList.add({
//             "title": titleTag.text.trim(),
//             "imageUrl": imageUrl,
//           });
//         }
//       }

//       // Extract Web Portal Training Section
//       final webPortalTitle = document.querySelector('h4')?.text.trim() ?? "";
//       final webPortalDescription = document.querySelectorAll('h4 + p');
//       String webPortalText = webPortalDescription.isNotEmpty ? webPortalDescription.map((e) => e.text.trim()).join("\n\n") : "";

//       // Preload Images
//       for (var item in fetchedList) {
//         if (item['imageUrl']!.isNotEmpty) {
//           precacheImage(NetworkImage(item['imageUrl']!), context);
//         }
//       }

//       setState(() {
//         pageTitle = extractedTitle;
//         titleImageList = fetchedList;
//         introDescription = introText;
//         webPortalHeading = webPortalTitle;
//         webPortalContent = webPortalText;
//       });

//     } else {
//       throw Exception('Failed to load page data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green.shade700,
//         elevation: 0,
//         title: Text(
//           "NEW STEPS SAFE FUTURE",
//           style: GoogleFonts.montserrat(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: titleImageList.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Page Title
//                     Text(
//                       pageTitle,
//                       style: GoogleFonts.montserrat(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),

//                     // Introductory Description
//                     Text(
//                       introDescription,
//                       style: TextStyle(fontSize: 14.sp, color: Colors.black87),
//                     ),
//                     SizedBox(height: 20),

//                     // GridView for Categories
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 10.h,
//                         crossAxisSpacing: 10.w,
//                         childAspectRatio: 1.1,
//                       ),
//                       itemCount: titleImageList.length,
//                       itemBuilder: (context, index) {
//                         return _buildGridItem(titleImageList[index]);
//                       },
//                     ),
//                     SizedBox(height: 20),

//                     // Web Portal Training Section
//                     Text(
//                       webPortalHeading,
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.montserrat(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),

//                     Text(
//                       webPortalContent,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 14.sp, color: Colors.black87),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildGridItem(Map<String, String> item) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Image.network(
//               item['imageUrl']!,
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               item['title']!,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.montserrat(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
