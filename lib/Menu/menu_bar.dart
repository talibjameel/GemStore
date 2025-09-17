// import 'package:flutter/material.dart';
//
// class CustomDrawer extends StatefulWidget {
//   const CustomDrawer({super.key});
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   bool isDarkMode = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔹 Profile Section
//               Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 28,
//                     backgroundImage: AssetImage("assets/profile.png"), // Replace with your asset
//                   ),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         "Sunie Pham",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         "sunieux@gmail.com",
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               const SizedBox(height: 30),
//
//               // 🔹 Menu Items
//               buildMenuItem(
//                 icon: Icons.home_outlined,
//                 label: "Homepage",
//                 isSelected: true,
//               ),
//               buildMenuItem(icon: Icons.search, label: "Discover"),
//               buildMenuItem(icon: Icons.shopping_bag_outlined, label: "My Order"),
//               buildMenuItem(icon: Icons.person_outline, label: "My profile"),
//
//               const SizedBox(height: 24),
//               const Text(
//                 "OTHER",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               buildMenuItem(icon: Icons.settings_outlined, label: "Setting"),
//               buildMenuItem(icon: Icons.mail_outline, label: "Support"),
//               buildMenuItem(icon: Icons.info_outline, label: "About us"),
//
//               const Spacer(),
//
//               // 🔹 Light/Dark Toggle
//               Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF3F3F3),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Light Button
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => setState(() => isDarkMode = false),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             color: !isDarkMode ? Colors.white : Colors.transparent,
//                             boxShadow: !isDarkMode
//                                 ? [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 4,
//                                 offset: const Offset(0, 2),
//                               )
//                             ]
//                                 : [],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: const [
//                               Icon(Icons.wb_sunny_outlined,
//                                   size: 18, color: Colors.black),
//                               SizedBox(width: 6),
//                               Text(
//                                 "Light",
//                                 style: TextStyle(
//                                     fontSize: 13, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     // Dark Button
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => setState(() => isDarkMode = true),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             color: isDarkMode ? Colors.white : Colors.transparent,
//                             boxShadow: isDarkMode
//                                 ? [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 4,
//                                 offset: const Offset(0, 2),
//                               )
//                             ]
//                                 : [],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: const [
//                               Icon(Icons.nightlight_round,
//                                   size: 18, color: Colors.black),
//                               SizedBox(width: 6),
//                               Text(
//                                 "Dark",
//                                 style: TextStyle(
//                                     fontSize: 13, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // 🔹 Reusable Menu Item
//   Widget buildMenuItem(
//       {required IconData icon,
//         required String label,
//         bool isSelected = false}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: isSelected ? const Color(0xFFF3F3F3) : Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Icon(icon,
//             color: isSelected ? Colors.black : Colors.black54, size: 22),
//         title: Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//             color: isSelected ? Colors.black : Colors.black87,
//           ),
//         ),
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//         dense: true,
//       ),
//     );
//   }
// }
