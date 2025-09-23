import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Models/product_model.dart';
import '../../Providers/category_provider.dart';


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
                            .state = cat.id!;
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
              data: (response) {
                final products = response.products ?? [];
                final banners = response.banners ?? [];

                if (products.isEmpty && banners.isEmpty) {
                  return const Center(child: Text("No products"));
                }

                // ✅ Split products by flags
                final featureProducts =
                products.where((p) => p.isFeatured == true).toList();
                final recommendedProducts =
                products.where((p) => p.isRecommended == true).toList();
                final topCollectionProducts =
                products.where((p) => p.topCollection == true).toList();

                // ✅ Split banners by position
                final topBanner =
                banners.where((b) => b.position?.toLowerCase() == "top").toList();
                final middleBanner =
                banners.where((b) => b.position?.toLowerCase() == "middle").toList();
                final bottomBanner =
                banners.where((b) => b.position?.toLowerCase() == "bottom").toList();

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    /// 🔹 Top Banner
                    if (topBanner.isNotEmpty) _buildBanner(topBanner.first),

                    /// 🔹 Feature Products
                    if (featureProducts.isNotEmpty) ...[
                      _buildSectionTitle("Feature Products"),
                      _buildProductGrid(featureProducts),
                    ],

                    /// 🔹 Middle Banner
                    if (middleBanner.isNotEmpty) _buildBanner(middleBanner.first),

                    /// 🔹 Recommended Products
                    if (recommendedProducts.isNotEmpty) ...[
                      _buildSectionTitle("Recommended"),
                      _buildProductList(recommendedProducts),
                    ],

                    /// 🔹 Top Collection Products
                    if (topCollectionProducts.isNotEmpty) ...[
                      _buildSectionTitle("Top Collection"),
                      _buildProductGrid(topCollectionProducts),
                    ],

                    SizedBox(height: 20),

                    /// 🔹 Bottom Banners Horizontal
                    if (bottomBanner.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bottomBanner.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final banner = bottomBanner[index];
                            // har banner ke andar multiple images hain, iterate karo
                            return Row(
                              children: banner.bannerImg!.map((imgUrl) {
                                return Container(
                                  width: 150,
                                  height: 350,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),

                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
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

  /// 🔹 Banner Widget
  Widget _buildBanner(BannerModel banner) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: banner.bannerImg?.length ?? 0,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          final imgUrl = banner.bannerImg![index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    "https://via.placeholder.com/300x150",
                    fit: BoxFit.cover,
                  ),
                ),
                if (banner.title != null || banner.description != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (banner.title != null)
                          Text(
                            banner.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (banner.description != null)
                          Text(
                            banner.description!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Show all",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// 🔹 Product Grid
  Widget _buildProductGrid(List<ProductModel> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(
                product.productImg ??
                    "https://via.placeholder.com/200x250", // 👈 use productImg
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black.withOpacity(0.4),
              padding: const EdgeInsets.all(6),
              child: Text(
                "${product.name}\nRs. ${product.price ?? '-'}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔹 Product List (Horizontal)
  Widget _buildProductList(List<ProductModel> products) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(
                  product.productImg ??
                      "https://via.placeholder.com/160x180", // 👈 use productImg
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                padding: const EdgeInsets.all(6),
                child: Text(
                  "${product.name}\nRs. ${product.price ?? '-'}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
