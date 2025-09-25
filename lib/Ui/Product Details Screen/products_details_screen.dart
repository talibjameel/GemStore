import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productName;
  final String productDescription;
  final String productPrice;
  final String productImage;
  final String size;
  final String color;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImage,
    required this.size,
    required this.color,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Stack(
        children: [
          // 🔹 Product Image Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.50,
              color: Colors.white,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: -120,
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEF2F2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Image.network(
                      widget.productImage,
                      height: 380,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 🔹 Back button
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.black, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Product details card with scrollable content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: SingleChildScrollView( // ✅ Prevent overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Title & Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.productName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(widget.productPrice,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 🔹 Rating
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                                  (index) => Icon(
                                index < 4 ? Icons.star : Icons.star_border,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('(83)', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // 🔹 Colors Dynamic
                      const Text('Color',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      // Row(
                      //   children: List.generate(
                      //     widget.colors.length,
                      //         (index) => _buildColorSwatch(widget.colors[index], index),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      // 🔹 Sizes Dynamic
                      const Text('Size',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      // Row(
                      //   children: List.generate(
                      //     widget.sizes.length,
                      //         (index) => _buildSizeButton(widget.sizes[index], index),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      _buildSection('Description'),
                      _buildSection('Reviews'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Add to cart
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
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
                    Icon(Icons.shopping_bag_outlined,
                        color: Colors.white, size: 24),
                    SizedBox(width: 10),
                    Text('Add To Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Color Swatch Builder
  Widget _buildColorSwatch(Color color, int index) {
    bool isSelected = _selectedColorIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedColorIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.blue, width: 3)
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }

  // 🔹 Size Button Builder
  Widget _buildSizeButton(String size, int index) {
    bool isSelected = _selectedSizeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedSizeIndex = index),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Center(
          child: Text(size,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Column(
      children: [
        const Divider(color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.grey, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}
