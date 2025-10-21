import 'dart:convert';
import 'package:ecommerce_store/APIs/Api%20Configuration%20Class/api_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Models/cart_model.dart';


final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<List<CartModel>>>(
      (ref) => CartNotifier(),
);
class CartNotifier extends StateNotifier<AsyncValue<List<CartModel>>> {
  CartNotifier() : super(const AsyncValue.loading()) {
    fetchCart();
  }

  final storage = const FlutterSecureStorage();
  double totalPrice = 0.0;

  /// ✅ Already working fine (untouched)
  Future<void> fetchCart() async {
    try {
      String? token = await ApiConfig.getToken();
      if (token == null) {
        state = const AsyncValue.error("Token not found", StackTrace.empty);
        return;
      }

      final response = await http.get(
        Uri.parse(ApiConfig.viewCart),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint(ApiConfig.viewCart);


      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          List<CartModel> items = (jsonData['data'] as List)
              .map((e) => CartModel.fromJson(e))
              .toList();

          totalPrice = (jsonData['total_price'] ?? 0).toDouble();
          state = AsyncValue.data(items);
        } else {
          state = const AsyncValue.error("Failed to load cart", StackTrace.empty);
        }
      } else {
        state = AsyncValue.error(
            "Error: ${response.statusCode}", StackTrace.empty);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// ✅ Add item to cart (use in Product Details)
  Future<void> addItemToCart({
    required String productId,
    required int quantity,
    required String price,
    required String size,
    required String color,
  })
  async {
    try {
      String? token = await ApiConfig.getToken();
      if (token == null) {
        throw Exception("Token not found");
      }

      final body = jsonEncode({
        "product_id": productId,
        "quantity": quantity,
        "price": price,
        "size": size,
        "color": color,
      });

      final response = await http.post(
        Uri.parse(ApiConfig.addItemToCart),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      debugPrint(ApiConfig.addItemToCart);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          // Refresh cart after adding item
          await fetchCart();
        } else {
          throw Exception(jsonData['message'] ?? "Failed to add item");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// ✅ Delete item from cart
  Future<void> removeItemFromCart(String cartId) async {
    try {
      String? token = await ApiConfig.getToken();
      if (token == null) {
        throw Exception("Token not found");
      }

      final url = Uri.parse(ApiConfig.deleteCartItem);
      final body = jsonEncode({"cart_id": cartId});

      // ✅ Use http.Request to allow sending a body with DELETE
      final request = http.Request("DELETE", url)
        ..headers["Authorization"] = "Bearer $token"
        ..headers["Content-Type"] = "application/json"
        ..body = body;

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);

      debugPrint(url.toString());
      debugPrint(body);

      if (response.statusCode == 200 && jsonData['success'] == true) {
        // ✅ Update local list
        state.whenData((list) {
          final updatedList = list.where((item) => item.cartId.toString() != cartId).toList();
          totalPrice = updatedList.fold(
            0.0,
                (sum, item) => sum + double.parse(item.price) * item.quantity,
          );
          state = AsyncValue.data(updatedList);
        });
      } else {
        throw Exception(jsonData['message'] ?? "Failed to delete item");
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Increase item quantity locally
  void increaseQuantity(int index) {
    state.whenData((list) {
      list[index].quantity++;
      calculateTotal(list);
    });
  }

  /// Decrease item quantity locally
  void decreaseQuantity(int index) {
    state.whenData((list) {
      if (list[index].quantity > 1) {
        list[index].quantity--;
        calculateTotal(list);
      }
    });
  }

  /// Recalculate total
  void calculateTotal(List<CartModel> list) {
    totalPrice = list.fold(
      0.0,
          (sum, item) => sum + double.parse(item.price) * item.quantity,
    );
    state = AsyncValue.data([...list]);
  }
}
