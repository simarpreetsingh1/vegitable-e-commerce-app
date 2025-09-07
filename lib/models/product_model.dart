class ProductModel {
  final String productImage;
  final String productName;
  final int productPrice;
  final String productId;
  final int productQuantity;
  final String productDescription; // Changed to uppercase D

  ProductModel({
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productId,
    required this.productQuantity,
    required this.productDescription, // Changed to uppercase D and made required
  });
}