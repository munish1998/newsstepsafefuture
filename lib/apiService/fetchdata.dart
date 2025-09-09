// import 'package:flutter/material.dart';
// import 'package:newsstepsafefuture/apiService/api.dart';
// import 'package:newsstepsafefuture/model/newModel.dart';


// class NewModelScreen extends StatefulWidget {
//   @override
//   _NewModelScreenState createState() => _NewModelScreenState();
// }

// class _NewModelScreenState extends State<NewModelScreen> {
//   late Future<NewModel?> futureData;

//   @override
//   void initState() {
//     super.initState();
//     futureData = ApiServices.fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("New Model Data")),
//       body: FutureBuilder<NewModel?>(
//         future: futureData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError || snapshot.data == null) {
//             return Center(child: Text("Failed to load data"));
//           }

//           NewModel data = snapshot.data!;
//           return Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("ID: ${data.id}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 Text("Name: ${data.name ?? 'N/A'}"),
//                 SizedBox(height: 8),
//                 Text("Description: ${data.description ?? 'N/A'}"),
//                 SizedBox(height: 8),
//                 Text("Link: ${data.link ?? 'N/A'}"),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
