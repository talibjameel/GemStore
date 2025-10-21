import 'package:ecommerce_store/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';
import '../../Widget/custom_appbar.dart';

class NotificationUi extends StatefulWidget {
  const NotificationUi({super.key});

  @override
  State<NotificationUi> createState() => _NotificationUiState();
}

class _NotificationUiState extends State<NotificationUi> {
  // 🔹 Example notification data (you will fetch from backend later)
  final List<Map<String, String>> notifications = [
    {
      "title": "Good morning! Get 20% Voucher",
      "subtitle": "Summer sale up to 20% off. Limited voucher. Get now!! 😜",
    },
    {
      "title": "Your order has been shipped",
      "subtitle": "Track your order #123456 for live updates.",
    },
    {
      "title": "Exclusive Offer 🎁",
      "subtitle": "Buy 1 Get 1 Free on selected items today only!",
    },
    {
      "title": "Flash Sale 🔥",
      "subtitle": "Hurry up! 50% off valid for the next 2 hours.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
          showBackButton: true,
          title: "Notification Screens"
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            notifications.length,
                (index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: TextWidget(
                  text: notifications[index]["title"] ?? "",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: TextWidget(
                    text: notifications[index]["subtitle"] ?? "",
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
