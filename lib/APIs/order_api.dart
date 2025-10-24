import 'dart:convert';

import 'package:ecommerce_store/APIs/Api%20Configuration%20Class/api_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MyOrders {

  Future<dynamic> placeOrders(
      int subTotal,
      int shippingCost,
      String status,
      )
  async {
    final url = ApiConfig.placeOrder;
    final token = await ApiConfig.getToken();
    final body = {
      "sub_total": subTotal,
      "shipping_cost": shippingCost,
      "status": status,
    };
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try{
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers
      );

      debugPrint('URL :$url');
      debugPrint("Response body: ${response.body}");



      if(response.statusCode == 200 || response.statusCode == 201){
        return jsonDecode(response.body);
      }else{
        throw Exception("Something went wrong");
      }
    }catch(e){
      debugPrint("$e");
    throw Exception("Something went wrong");
    }
  }


  Future<dynamic>  getMyOrders() async {
    final url = ApiConfig.myOrders;
    final token = await ApiConfig.getToken();
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try{
      final response = await http.get(
        Uri.parse(url),
        headers: headers
      );

      debugPrint('URL :$url');
      debugPrint("Response body: ${response.body}");


      if(response.statusCode == 200){
        return jsonDecode(response.body);



      }else{
        throw Exception("Something went wrong");
      }
    }catch(e){
      debugPrint("$e");
      throw Exception("Something went wrong");
    }
  }
}