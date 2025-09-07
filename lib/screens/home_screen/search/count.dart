import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/reviewcart_provider.dart';

class Count extends StatelessWidget {
  final String productName;
  final String productImage;
  final String productId;
  final int productPrice;

  const Count({
    Key? key,
    required this.productName,
    required this.productImage,
    required this.productId,
    required this.productPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviewCartProvider = Provider.of<ReviewCartProvider>(context);

    // Get the current quantity from the provider
    final cartItem = reviewCartProvider.getReviewCartDataList
        .firstWhere((item) => item.cartId == productId);
    final currentQuantity = cartItem.cartQuantity;

    return Container(
      height: 25,
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              if (currentQuantity > 1) {
                reviewCartProvider.updateReviewCartData(
                  cartId: productId,
                  cartQuantity: currentQuantity - 1,
                );
              } else {
                reviewCartProvider.reviewCartDataDelete(productId);
              }
            },
            child: const Icon(Icons.remove, size: 15),
          ),
          Text("$currentQuantity", style: const TextStyle(fontSize: 12)),
          InkWell(
            onTap: () {
              reviewCartProvider.updateReviewCartData(
                cartId: productId,
                cartQuantity: currentQuantity + 1,
              );
            },
            child: const Icon(Icons.add, size: 15),
          ),
        ],
      ),
    );
  }
}