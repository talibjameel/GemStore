import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Api Configuration Class/api_configuration.dart';

class ApiService {

  // 🔹 Secure Storage
  final storage = const FlutterSecureStorage();


  // 🔹 Signup
  Future<Map<String, dynamic>> signUp(String name, String email, String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.signUp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        }),
      );

      debugPrint(ApiConfig.signUp);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final jwtToken = data["jwt_token"];
        await storage.write(key: "jwt_token", value: jwtToken);

        return {
          "message": data["message"],
          "jwt_token": data["jwt_token"],
          "user": data["user"],
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["message"] ?? "Signup failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // 🔹 Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      debugPrint(ApiConfig.login);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final jwtToken = data["jwt_token"];
        await storage.write(key: "jwt_token", value: jwtToken);
        debugPrint(jwtToken);

        return {
          "message": data["message"],
          "jwt_token": data["jwt_token"],
          "user": data["user"],
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["message"] ?? "Login failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // 🔹 Forgot Password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.forgotPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }),
      );

      debugPrint(ApiConfig.forgotPassword);

      if (response.statusCode == 200 ) {
        return jsonDecode(response.body);

      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["message"] ?? "Forgot password failed");
      }
  } catch (e) {
    throw Exception("Error: $e");}
  }

  // 🔹 OTP Verification
  Future<Map<String, dynamic>> otpVerification(String email,String otp) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.otpVerification),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      debugPrint(ApiConfig.otpVerification);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["message"] ?? "OTP verification failed");
      }
  } catch (e) {
    throw Exception("Error: $e");}
  }

  // 🔹 Update Password
  Future<Map<String, dynamic>> updatePassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.updatePassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "newPassword": newPassword,
        }),
      );

      debugPrint(ApiConfig.updatePassword);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["message"] ?? "Update password failed");
      }
   } catch (e) {
    throw Exception("Error: $e");
    }
  }
}
