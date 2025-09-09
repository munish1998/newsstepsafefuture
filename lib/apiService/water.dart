// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:newsstepsafefuture/apiService/apiwater.dart';
// import 'package:newsstepsafefuture/model/fetchModel.dart';

// class PagesScreen extends StatefulWidget {
//   @override
//   _PagesScreenState createState() => _PagesScreenState();
// }

// class _PagesScreenState extends State<PagesScreen> {
//   late Future<List<FetchModel>> _pagesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _pagesFuture = ApiService().fetchPages();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Pages")),
//       body: FutureBuilder<List<FetchModel>>(
//         future: _pagesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No pages found"));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               FetchModel page = snapshot.data![index];
//               return Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         page.title?.rendered ?? "No Title",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       Html(data: page.content?.rendered ?? "No Content"), // Render HTML properly
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
