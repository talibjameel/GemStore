import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../APIs/Categories Api/product_by_id_api.dart';
import '../Models/product_model.dart';

// API Provider
final productsApiProvider = Provider<ProductApi>((ref) {
  return ProductApi();
});

// Products by category
final productProvider = FutureProvider.family<List<ProductModel>, int>((ref, categoryId) async {
  final api = ref.read(productsApiProvider);
  return api.getProductsByCategory(categoryId);
});

// ✅ Selected category ID
final selectedCategoryIdProvider = StateProvider<int>((ref) => 1);
