import 'package:carousel_slider/carousel_slider.dart';
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
    // 👇 Watch selected category id
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    // 👇 Watch categories data
    final categoryAsync = ref.watch(categoryProvider);

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
                          final newCatId = cat.id ?? 0;
                          debugPrint("UI: Tapped category '${cat.name}', original cat.id: ${cat.id}, ID sent to provider: $newCatId");
                          ref
                              .read(selectedCategoryIdProvider.notifier)
                              .state = newCatId;
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
                              color: isSelected
                                  ? Colors.black
                                  : Colors.black54,
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

                // 🔥 Same logic as before
                final featureProducts =
                products.where((p) => p.isFeatured == true).toList();
                final recommendedProducts =
                products.where((p) => p.isRecommended == true).toList();
                final topCollectionProducts =
                products.where((p) => p.topCollection == true).toList();

                final topBanner = banners
                    .where((b) => b.position?.toLowerCase() == "top")
                    .toList();
                final middleBanner = banners
                    .where((b) => b.position?.toLowerCase() == "middle")
                    .toList();
                final bottomBanner = banners
                    .where((b) => b.position?.toLowerCase() == "bottom")
                    .toList();

                return ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  children: [
                    if (topBanner.isNotEmpty)
                      BannerSlider(banner: topBanner.first),

                    if (featureProducts.isNotEmpty) ...[
                      _buildSectionTitle("Feature Products"),
                      _buildProductGrid(featureProducts),
                    ],

                    const SizedBox(height: 20),
                    if (middleBanner.isNotEmpty)
                      _buildBanner(
                        middleBanner.first,
                        showIndicator: false,
                        showTitle: false,
                        showDescription: false,
                      ),

                    if (recommendedProducts.isNotEmpty) ...[
                      _buildSectionTitle("Recommended"),
                      _buildProductList(recommendedProducts),
                    ],

                    if (topCollectionProducts.isNotEmpty) ...[
                      _buildSectionTitle("Top Collection"),
                      _buildProductGrid(topCollectionProducts),
                    ],

                    const SizedBox(height: 20),

                    if (bottomBanner.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bottomBanner.length,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final banner = bottomBanner[index];
                            return Row(
                              children: banner.bannerImg!.map((imgUrl) {
                                return Container(
                                  width: 150,
                                  height: 350,
                                  margin:
                                  const EdgeInsets.only(right: 12),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
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
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Error: $err")),
            ),
          ),
        ],
      ),
    );
  }

  _buildBanner(BannerModel banner, {bool showIndicator = true, bool showTitle = true, bool showDescription = true})
  {
    return BannerSlider(
        banner: banner,
        showIndicator: showIndicator,
        showTitle: showTitle,
        showDescription: showDescription
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: const Center(child: Text("Drawer Placeholder")),
    );
  }

  /// 🔹 Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.zero,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ==== Product Card with only Image ====
            Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: Image.network(
                  product.productImg ??
                      "https://via.placeholder.com/300x400",
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, st) => Image.network(
                    "https://via.placeholder.com/300x400",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // ==== Title & Price OUTSIDE the card ====
            const SizedBox(height: 6),
            Text(
              product.name ?? "No name",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Text(
              "\$ ${product.price ?? '-'}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B5E20), // green price color
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Product List (Horizontal)
  Widget _buildProductList(List<ProductModel> products) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 240,
              color: Colors.white,
              child: Row(
                children: [
                  // ==== Product Image ====
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.productImg ??
                          "https://via.placeholder.com/100x100",
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ==== Product Info ====
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name ?? "No name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$ ${product.price ?? '-'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1B5E20), // dark green price
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

class BannerSlider extends StatefulWidget {
  final BannerModel banner;
  final bool showIndicator;
  final bool showTitle;
  final bool showDescription;

  const BannerSlider({
    super.key,
    required this.banner,
    this.showIndicator = true,
    this.showTitle = true,
    this.showDescription = true,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}
class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.banner.bannerImg ?? [];

    if (images.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("No banners available")),
      );
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            height: 180,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final imgUrl = images[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.network(
                          "https://via.placeholder.com/300x150",
                          fit: BoxFit.cover,
                        ),
                  ),

                  // Gradient + Title/Description on LEFT side
                  if (widget.showTitle || widget.showDescription)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 60,left: 20),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.showTitle && widget.banner.title != null)
                            Text(
                              widget.banner.title!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (widget.showDescription && widget.banner.description != null)
                            const SizedBox(height: 8),
                          if (widget.showDescription && widget.banner.description != null)
                            Text(
                              widget.banner.description!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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

        // Dots indicator
        if (widget.showIndicator)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                    (index) {
                  final isActive = _currentIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 12 : 8,
                    height: isActive ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}