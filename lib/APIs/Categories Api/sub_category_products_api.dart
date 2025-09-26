import 'dart:convert';
import 'package:ecommerce_store/APIs/Api%20Configuration%20Class/api_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../Models/product_model.dart';

class SubCategoryProductsApi {
  final storage = const FlutterSecureStorage();

  /// 🔹 Ek hi function dono URL handle karega
  Future<List<ProductModel>> getProducts({
    required String value,
    bool isSubCategory = true,
  }) async {
    final token = await storage.read(key: "jwt_token");

    /// 🔹 Select URL based on condition
    final String url = isSubCategory
        ? ApiConfig.subCategories.replaceAll(":string", value.toString())
        : ApiConfig.productsType.replaceAll(":string", value.toString());

    debugPrint("👉 Final Products Url : $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    debugPrint("✅ API Response: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['products'] != null) {
        List productsJson = data['products'];
        return productsJson
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw Exception("Products key not found in API response");
      }
    } else {
      throw Exception("Failed to load products");
    }
  }
}
