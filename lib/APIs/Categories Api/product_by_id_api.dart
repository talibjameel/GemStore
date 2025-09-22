import 'dart:convert';
import 'package:ecommerce_store/APIs/Api%20Configuration%20Class/api_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../Models/product_model.dart';

class ProductApi {
  final storage = const FlutterSecureStorage();

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final token = await storage.read(key: "jwt_token");


    // ✅ Correct: replace :id with actual categoryId
    final url = ApiConfig.categoriesProducts.replaceAll(":id", categoryId.toString());

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
      final List products = data['products'] as List;
      return products.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
