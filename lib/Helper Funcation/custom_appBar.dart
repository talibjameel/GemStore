// import 'package:flutter/material.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool showNotification;
//
//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.showNotification = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       leading: Builder(
//         builder: (context) => IconButton(
//           icon: const Icon(Icons.menu, color: Colors.black),
//           onPressed: () => Scaffold.of(context).openDrawer(),
//         ),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(fontSize: 22, color: Colors.black),
//       ),
//       actions: [
//         if (showNotification)
//           Padding(
//             padding: const EdgeInsets.only(right: 15),
//             child: IconButton(
//               onPressed: () =>
//                   Navigator.pushNamed(context, '/NotificationUI'),
//               icon: const Icon(Icons.notifications_none, color: Colors.black),
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
