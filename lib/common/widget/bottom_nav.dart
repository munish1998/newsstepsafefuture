// import 'package:flutter/material.dart';
// import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
// import 'package:newsstepsafefuture/Screen/dashboard/home.dart';
// import 'package:newsstepsafefuture/utils/colors.dart';

// class PagesWidget extends StatefulWidget {
//   final int initialTab;
//   final bool isRideReceived;

//   PagesWidget({
//     Key? key,
//     this.initialTab = 0,
//     this.isRideReceived = false,
//   }) : super(key: key);

//   @override
//   _PagesWidgetState createState() => _PagesWidgetState();
// }

// class _PagesWidgetState extends State<PagesWidget> {
//   late int currentTab;

//   @override
//   void initState() {
//     super.initState();
//     currentTab = widget.initialTab;
//   }

//   void _selectTab(int tabItem) {
//     setState(() {
//       currentTab = tabItem;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: currentTab == 0
//           ? HomeScreen() // You can replace this with other pages like PastHistory or Profile
//           : currentTab == 1
//               ? Center(child: Text('Past History Page'))
//               : Center(child: Text('Profile Page')),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: AppColors.green, // Set the background color to green
//           borderRadius: BorderRadius.circular(5), // Make it rectangular
//         ),
//         child: FancyBottomNavigation(
//           barBackgroundColor: AppColors.green, // Your desired background color
//           circleColor: Colors.white, // Circle color on active tab
//           inactiveIconColor: Colors.black, // Color for inactive icons
//           activeIconColor: Colors.white, // Color for active icons (for contrast)
//           initialSelection: widget.initialTab,
//           onTabChangedListener: (int i) {
//             _selectTab(i); // Updates the selected tab
//           },
//           tabs: [
//             TabData(iconData: Icons.home, title: "Home"),
//             TabData(iconData: Icons.search, title: "Search"),
//             TabData(iconData: Icons.menu, title: "Menu"),
//           ],
//         ),
//       ),
//     );
//   }
// }
