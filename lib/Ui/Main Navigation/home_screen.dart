import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Providers/category_provider.dart';
import '../../Providers/products_provider_by_id.dart';
import '../../Models/product_model.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(categoryProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'GemStore',
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, '/NotificationUI'),
              icon: const Icon(Icons.notifications_none, color: Colors.black),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          /// 🔹 Categories Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: categoryAsync.when(
              data: (categoryResponse) {
                final categories = categoryResponse.categories ?? [];

                if (categories.isEmpty) {
                  return const Center(child: Text("No categories"));
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(categories.length, (index) {
                    final cat = categories[index];
                    final bool isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        ref
                            .read(selectedCategoryIdProvider.notifier)
                            .state = categories[index].id!;
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFF3A2C27)
                                  : Colors.transparent,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? const Color(0xFF3A2C27)
                                    : const Color(0xFFF3F3F3),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: SvgPicture.network(
                                cat.icon.toString(),
                                colorFilter: isSelected
                                    ? const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn)
                                    : const ColorFilter.mode(
                                    Colors.grey, BlendMode.srcIn),
                                height: 24,
                                width: 24,
                                fit: BoxFit.contain,
                                placeholderBuilder: (context) =>
                                const CircularProgressIndicator(),
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 24, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cat.name ?? "No Name",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color:
                              isSelected ? Colors.black : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("Error loading categories: $err")),
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 Products List
          Expanded(
            child: ref.watch(productProvider(selectedCategoryId)).when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text("No products"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final ProductModel product = products[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(product.name ?? ''),
                        subtitle: Text("Rs. ${product.price ?? '-'}"),
                        trailing: product.stock != null
                            ? Text("Stock: ${product.stock}")
                            : null,
                      ),
                    );
                  },
                );
              },
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Error: $err")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: const Center(child: Text("Drawer Placeholder")),
    );
  }
}
