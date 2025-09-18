import 'package:riverpod/riverpod.dart';
import '../APIs/Categories Api/categories_api.dart';
import '../Models/categories_model.dart';

/// 🔹 1. API service ko expose karna
final categoryApiProvider = Provider<CategoryApi>((ref) {
  return CategoryApi();
});

/// 🔹 2. FutureProvider model ko use kar ky API ko call karega
final categoryProvider = FutureProvider<CategoryResponse>((ref) async {
  final api = ref.read(categoryApiProvider);
  return api.getCategory();
});
