import 'package:flutter_riverpod/flutter_riverpod.dart';

// Shipping method
final shippingProvider = StateProvider<String>((ref) => "free");

// Shipping address
final addressProvider = StateProvider<String>((ref) => "");
