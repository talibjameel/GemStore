// import 'dart:convert';
// import 'package:ecommerce_store/APIs/Api%20Configuration%20Class/api_configuration.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../Models/product_model.dart';
//
// class FeatureProductsApi {
//   final storage = const FlutterSecureStorage();
//
//   Future<List<ProductModel>> getFeaturedProducts(productsName) async {
//     final token = await storage.read(key: "jwt_token");
//
//     final url =
//     ApiConfig.featureProducts.replaceAll(":string", productsName.toString());
//
//     debugPrint("SubCategory Products Url : $url");
//
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     debugPrint("✅ API Response: ${response.body}");
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//
//       if (data['products'] != null) {
//         // 🔹 Map each product JSON to ProductModel
//         List productsJson = data['products'];
//         return productsJson
//             .map((product) => ProductModel.fromJson(product))
//             .toList();
//       } else {
//         throw Exception("Products key not found in API response");
//       }
//     } else {
//       throw Exception("Failed to load products & banners");
//     }
//   }
// }
