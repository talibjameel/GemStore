// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/cart_model.dart';
// import 'Api Configuration Class/api_configuration.dart';
//
// class CartApi {
//
//
//
//   // ✅ Fetch all cart items
//   static Future<Map<String, dynamic>> fetchCartItems() async {
//     final url = Uri.parse(ApiConfig.cart);
//     final token = await ApiConfig.getToken();
//
//
//     final response = await http.get(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//
//       if (jsonData['success'] == true) {
//         final List<dynamic> list = jsonData['data'] ?? [];
//         final List<CartModel> cartItems =
//         list.map((e) => CartModel.fromJson(e)).toList();
//
//         return {
//           "success": true,
//           "totalPrice": jsonData['total_price'] ?? 0.0,
//           "data": cartItems,
//         };
//       } else {
//         return {"success": false, "message": "No data found"};
//       }
//     } else {
//       return {
//         "success": false,
//         "message": "Server error: ${response.statusCode}"
//       };
//     }
//   }
// }
