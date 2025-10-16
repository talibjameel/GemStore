class CartModel {
  final int cartId;
  final String title;
  final String price;
  final String productImg;
  final String color;
  final String size;
  int quantity;

  CartModel({
    required this.cartId,
    required this.title,
    required this.price,
    required this.productImg,
    required this.color,
    required this.size,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cart_id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price'] ?? '0.0',
      productImg: json['product_img'] ?? '',
      color: json['color'] ?? '',
      size: json['size'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }
}
