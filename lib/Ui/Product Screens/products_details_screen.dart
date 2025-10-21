import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Providers/cart_api_and_provider.dart';


class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  final String productName;
  final String productDescription;
  final String productPrice;
  final String productImage;
  final String size;
  final String color;
  final String rating;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImage,
    required this.size,
    required this.color,
    required this.rating,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}
class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 0;

  late List<String> sizes;
  late List<String> colors;

  @override
  void initState() {
    super.initState();

    sizes = widget.size.isNotEmpty
        ? widget.size.split(',').map((e) => e.trim()).toList()
        : [];

    colors = widget.color.isNotEmpty
        ? widget.color.split(',').map((e) => e.trim()).toList()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Stack(
        children: [
          // 🔹 Full width Product Image Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.50,
              width: double.infinity,
              child: Image.network(
                widget.productImage,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.black, size: 20),
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Product details card with scrollable content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Title & Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.productName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                          Text("\$${widget.productPrice}",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),

                      /// 🔹 Rating
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                                  (index) => Icon(
                                index < double.parse(widget.rating).round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.rating,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Colors & Sizes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 🔹 Colors Dynamic
                          if (colors.isNotEmpty) ...[
                            Column(
                              children: [
                                const Text(
                                    'Colors',
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 10),
                                Row(
                                  children: List.generate(
                                    colors.length,
                                        (index) => _buildColorCircle(colors[index], index),
                                  ),
                                ),
                              ],
                            )
                          ],

                          // 🔹 Sizes Dynamic
                          if (sizes.isNotEmpty) ...[
                            Column(
                              children: [
                                const Text('Sizes',
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 10),
                                Row(
                                  children: List.generate(
                                    sizes.length,
                                        (index) => _buildSizeButton(sizes[index], index),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ],
                      ),


                      ExpandableSection(title: 'Description',value:  widget.productDescription),
                      ExpandableSection(title: 'Reviews' ,value:  "No reviews yet."),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// ✅ Add to cart button
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                final selectedSize = sizes.isNotEmpty ? sizes[_selectedSizeIndex] : 'M';
                final selectedColor = colors.isNotEmpty ? colors[_selectedColorIndex] : 'White';

                // 🔹 Add to Cart API call
                await cartNotifier.addItemToCart(
                  productId: widget.productId,
                  quantity: 1,
                  price: widget.productPrice,
                  size: selectedSize,
                  color: selectedColor,
                );

                // 🔹 Navigate only after successful add
                if (mounted) {
                  Navigator.pushNamed(context, '/CartScreen');
                }
              },
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Add To Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Color Circle Builder (based on backend color name)
  Widget _buildColorCircle(String colorName, int index) {
    bool isSelected = _selectedColorIndex == index;

    final Map<String, Color> colorMap = {
      'black': Colors.black,
      'white': Colors.white,
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'grey': Colors.grey,
      'brown': Colors.brown,
    };

    Color circleColor = colorMap[colorName.toLowerCase().trim()] ?? Colors.grey;

    return GestureDetector(
      onTap: () => setState(() => _selectedColorIndex = index),
      child: Material(
        shape: const CircleBorder(),
        elevation: isSelected ? 6 : 2,
        shadowColor: Colors.black26,
        child: Container(
          width: 35,
          height: 35,
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(
              color: isSelected ? Colors.white70 : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }


  // 🔹 Size Button Builder
  Widget _buildSizeButton(String size, int index) {
    bool isSelected = _selectedSizeIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedSizeIndex = index),
      child: Container(
        width: 35,
        height: 35,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFF515151) : const Color(0xFFFAFAFA),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableSection extends StatefulWidget {
  final String title;
  final String value;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}
class _ExpandableSectionState extends State<ExpandableSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Color(0xFFF3F3F6)),
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // 🔹 Show content only when expanded
        if (_isExpanded)
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              widget.value,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
      ],
    );
  }
}