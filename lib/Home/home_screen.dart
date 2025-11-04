// import 'package:flutter/material.dart';
// import 'package:newsstepsafefuture/Home/home_widget.dart';
// import 'home_controller.dart';

// class HomeScreen extends StatefulWidget {
//   final Function(Locale) setLocale;
//   const HomeScreen({super.key, required this.setLocale});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final controller = HomeController();
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     controller.init().then((_) async {
//       await controller.fetchPageData(context);
//       setState(() => isLoading = false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Text(controller.pageTitle, style: const TextStyle(fontSize: 22)),
//                 const SizedBox(height: 10),
//                 Text(controller.introDescription),
//                 const SizedBox(height: 20),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: controller.titleImageList.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2, childAspectRatio: 1.1),
//                   itemBuilder: (context, index) {
//                     return buildGridItem(
//                       controller.titleImageList[index],
//                       controller.categories[index],
//                       () {},
//                     );
//                   },
//                 )
//               ],
//             ),
//     );
//   }
// }
