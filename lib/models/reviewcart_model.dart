class ReviewCartModel {
  final String cartImage;
  final String cartName;
  final String cartId;
  final int cartPrice;
  final int cartQuantity;

  ReviewCartModel({
    required this.cartImage,
    required this.cartName,
    required this.cartId,
    required this.cartPrice,
    required this.cartQuantity,
  });

  // Add copyWith method for easy updates
  ReviewCartModel copyWith({
    String? cartImage,
    String? cartName,
    String? cartId,
    int? cartPrice,
    int? cartQuantity,
  }) {
    return ReviewCartModel(
      cartImage: cartImage ?? this.cartImage,
      cartName: cartName ?? this.cartName,
      cartId: cartId ?? this.cartId,
      cartPrice: cartPrice ?? this.cartPrice,
      cartQuantity: cartQuantity ?? this.cartQuantity,
    );
  }
}