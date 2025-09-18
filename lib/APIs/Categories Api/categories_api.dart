import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Api Configuration Class/api_configuration.dart';
import '../../Models/categories_model.dart';

class CategoryApi{
  final storage = FlutterSecureStorage();

  Future<CategoryResponse> getCategory() async {
    try{
      final token = await storage.read(key: "jwt_token");

      final response = await http.get(
        Uri.parse(ApiConfig.categories),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint(token);
      debugPrint(ApiConfig.categories);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        debugPrint("✅ API Response: $data"); // add this
        return CategoryResponse.fromJson(data);
      } else {
        debugPrint("❌ Error Response: ${response.body}");
        throw Exception("Something went wrong: ${response.statusCode}");
      }


    }catch(e){
      throw Exception("Something went wrong");
    }
  }
}