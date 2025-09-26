class ApiConfig {
  // Base URL
  static const String baseUrl = "http://localhost:8600";

  // Endpoints
  static const String login = "$baseUrl/login";
  static const String signUp = "$baseUrl/signup";
  static const String forgotPassword = "$baseUrl/forgot-password";
  static const String otpVerification = "$baseUrl/verify-otp";
  static const String updatePassword = "$baseUrl/update-password";
  static const String categories = "$baseUrl/categories";
  static const String categoriesProducts = "$baseUrl/products/category/:id";
  static const String subCategories = "$baseUrl/subcategories/:string";
  static const String productsType = "$baseUrl/products/:string";

}
