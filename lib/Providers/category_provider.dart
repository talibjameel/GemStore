import '../APIs/Categories Api/categories_api.dart';
import '../Models/categories_model.dart';
import '../Models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../APIs/Categories Api/product_by_id_api.dart';



/// ✅ Categories API expose karna
final categoryApiProvider = Provider<CategoryApi>((ref) {
  return CategoryApi();
});

/// ✅ Products API expose karna
final productsApiProvider = Provider<ProductApi>((ref) {
  return ProductApi();
});

/// ✅ Categories ke liye FutureProvider (CategoryResponse use karega)
final categoryProvider = FutureProvider<CategoryResponse>((ref) async {
  final api = ref.read(categoryApiProvider);
  return api.getCategory();
});

/// ✅ Products ke liye FutureProvider.family (Category ke hisaab se products fetch karega)
final productProvider =
FutureProvider.family<ProductBannerResponse, int>((ref, categoryId) async {
  final api = ref.read(productsApiProvider);
  return api.getProductsByCategory(categoryId);
});

/// ✅ Selected Category ID StateProvider
final selectedCategoryIdProvider = StateProvider<int>((ref) => 1);


/// ✅ refresh categories
final categoryRefreshProvider = Provider((ref) {
  return () {
    ref.invalidate(categoryProvider);
  };
});

/// ✅ refresh products
final productRefreshProvider = Provider((ref) {
  return () {
    ref.invalidate(productProvider);
  };
});
