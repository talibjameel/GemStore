import 'package:ecommerce_store/Ui/Product%20Details%20Screen/products_details_screen.dart';
import 'package:flutter/material.dart';
import '../../APIs/Categories Api/sub_category_products_api.dart';
import '../../Models/product_model.dart';

class SubCategoryProductsScreen extends StatefulWidget {
  final String subCategoryName;
  final bool isSubCategory;

  const SubCategoryProductsScreen({super.key, required this.subCategoryName, required this.isSubCategory});

  @override
  State<SubCategoryProductsScreen> createState() =>
      _SubCategoryProductsScreenState();
}
class _SubCategoryProductsScreenState extends State<SubCategoryProductsScreen> {
  late Future<List<ProductModel>> _productFuture;
   var faveList = false;

  @override
  void initState() {
    super.initState();
    _productFuture = SubCategoryProductsApi().getProducts(value: widget.subCategoryName, isSubCategory: widget.isSubCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.subCategoryName.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found"));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index]);
              },
            );
          }
        },
      ),
    );
  }

// 🔹 Product Card Widget
  Widget _buildProductCard(ProductModel product) {
    double rating = double.tryParse(product.rating ?? "0") ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productName: product.name.toString(),
              productDescription: product.description.toString(),
              productPrice: product.price.toString(),
              productImage: product.productImg.toString(),
              size: product.size.toString(),
              color: product.colors.toString(),
              rating: product.rating.toString(),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Product Image inside Card
          Stack(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    product.productImg ?? "",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        faveList = !faveList;
                      });
                    },
                    icon: faveList ? const Icon(Icons.favorite, color: Colors.red) : const Icon(Icons.favorite_border, color: Colors.black),
                  ),
                  ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 Product Image inside Card
          Padding(
           padding: EdgeInsets.only(left: 15),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               /// 🔹 Product Name
               Text(
                 product.name ?? "",
                 style: const TextStyle(
                   fontSize: 14,
                   fontWeight: FontWeight.w600,
                 ),
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
               ),

               /// 🔹 Product Price
               Text(
                 "\$${product.price}",
                 style: const TextStyle(
                   fontSize: 13,
                   fontWeight: FontWeight.bold,
                   color: Colors.black,
                 ),
               ),

               /// 🔹 Product Rating (Stars)
               Row(
                 children: List.generate(5, (index) {
                   if (index < rating.floor()) {
                     return const Icon(Icons.star, color: Colors.green, size: 16);
                   } else if (index < rating && rating % 1 != 0) {
                     return const Icon(Icons.star_half, color: Colors.green, size: 16);
                   } else {
                     return const Icon(Icons.star_border,
                         color: Colors.green, size: 16);
                   }
                 }),
               ),
             ],
           ),
         )
        ],
      ),
    );
  }
}
