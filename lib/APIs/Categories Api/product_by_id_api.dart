import 'dart:convert';
import 'package:ecommerce_store/APIs/Api%20Configuration%20Class/api_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../Models/product_model.dart';


class ProductApi {
  final storage = const FlutterSecureStorage();

  Future<ProductBannerResponse> getProductsByCategory(int categoryId) async {
    final token = await storage.read(key: "jwt_token");

    // ✅ Replace :id with categoryId in API URL
    final url =
    ApiConfig.categoriesProducts.replaceAll(":id", categoryId.toString());

    debugPrint("Url : $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    debugPrint("✅ API Response: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ProductBannerResponse.fromJson(data);
    } else {
      throw Exception("Failed to load products & banners");
    }
  }
}
