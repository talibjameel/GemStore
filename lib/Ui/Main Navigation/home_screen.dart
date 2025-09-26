import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_store/Helper%20Funcation/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Models/product_model.dart';
import '../../Providers/category_provider.dart';
import '../Product Details Screen/products_details_screen.dart';
import '../Product Details Screen/sub_category_products.dart';


class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}
class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    /// Watch selected category id
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    /// Watch categories data
    final categoryAsync = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
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
      drawer:CustomNavigationDrawer(),
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
                      _buildSectionTitle("Feature Products",(){

                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            SubCategoryProductsScreen(subCategoryName: "featured",isSubCategory: false)
                          )
                        );

                      }),
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
                      _buildSectionTitle("Recommended",(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            SubCategoryProductsScreen(subCategoryName: "recommended",isSubCategory: false)
                          )
                        );
                      }),
                      _buildProductList(recommendedProducts),
                    ],

                    if (topCollectionProducts.isNotEmpty) ...[
                      _buildSectionTitle("Top Collection",(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            SubCategoryProductsScreen(subCategoryName: "topCollection",isSubCategory: false)
                         )
                        );
                      }),
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
                            return GestureDetector(
                              onTap: (){
                                debugPrint("SubCategory name : ${banner.title}");
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    SubCategoryProductsScreen(
                                        subCategoryName: banner.title.toString(),
                                        isSubCategory: true
                                    )
                                  )
                                );
                              },
                              child: Row(
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
                              ),
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

  /// 🔹 Section Title Widget
  Widget _buildSectionTitle(String title,VoidCallback onPressed) {
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
          TextButton(
            onPressed: onPressed,
            child: Text(
              "Show all",
              style: TextStyle(color: Colors.grey),
            ),
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

        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                ProductDetailScreen(
                  productName: product.name.toString(),
                  productDescription: product.description.toString(),
                  productPrice: product.price!.toString(),
                  productImage: product.productImg.toString(),
                  size: product.size.toString(),
                  color: product.colors.toString(),
                  rating: product.rating.toString(),
                )
            ));
          },
          child: Column(
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
          ),
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

          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
              ProductDetailScreen(
                  productName: product.name.toString(),
                  productDescription: product.description.toString(),
                  productPrice: product.price!.toString(),
                  productImage: product.productImg.toString(),
                  size: product.size.toString(),
                  color: product.colors.toString(),
                  rating: product.rating.toString(),
              )
              ));
            },
            child: Card(
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
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
                            Colors.black.withValues(alpha: .6),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 60,left: 215),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.showTitle && widget.banner.title != null)
                            TextWidget(
                              text:widget.banner.title!.replaceAll(r'\n', '\n'),
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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
                      color: isActive ? Colors.white : Colors.white.withValues(alpha:0.4),
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


class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.75, // 75% screen width
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Profile Section
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Sunie Pham",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "sunieux@gmail.com",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 Menu Items
              _buildDrawerItem(Icons.home, "Homepage", true),
              _buildDrawerItem(Icons.search, "Discover"),
              _buildDrawerItem(Icons.shopping_bag_outlined, "My Order"),
              _buildDrawerItem(Icons.person_outline, "My Profile"),

              const SizedBox(height: 10),
              const Text(
                "OTHER",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              _buildDrawerItem(Icons.settings_outlined, "Setting"),
              _buildDrawerItem(Icons.email_outlined, "Support"),
              _buildDrawerItem(Icons.info_outline, "About us"),

              const Spacer(),

              /// 🔹 Light / Dark Toggle
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildToggleButton(Icons.wb_sunny_outlined, "Light", true),
                    _buildToggleButton(Icons.nightlight_round, "Dark", false),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Drawer Item Builder
  Widget _buildDrawerItem(IconData icon, String title, [bool selected = false]) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.grey.shade100 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? Colors.black : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: selected ? FontWeight.bold : FontWeight.w400,
            color: selected ? Colors.black : Colors.grey.shade700,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  /// 🔹 Theme Toggle Button
  Widget _buildToggleButton(IconData icon, String label, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: active
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: active ? Colors.black : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}