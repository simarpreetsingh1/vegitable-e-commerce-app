import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/reviewcart_provider.dart';
import 'package:restaurant/screens/home_screen/search/count.dart';

class SearchItems extends StatelessWidget {
  final bool isBool;
  final String productImage;
  final String productName;
  final int productPrice;
  final String productId;
  final int productQuantity;
  final bool wishListBool;
  final VoidCallback? onDelete;
  final VoidCallback? onTap; // Add onTap callback

  const SearchItems({
    super.key,
    this.isBool = false,
    this.wishListBool = false,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productId,
    required this.productQuantity,
    this.onDelete,
    this.onTap, // Add onTap parameter
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewCartProvider>(
      builder: (context, reviewCartProvider, child) {
        final isInCart = reviewCartProvider.isProductInCart(productId);

        return GestureDetector(
          onTap: onTap, // Use the onTap callback
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    // Product Image
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: Center(
                          child: Image.network(productImage),
                        ),
                      ),
                    ),

                    // Product Details
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: Column(
                          mainAxisAlignment: isBool
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "₹$productPrice",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                isBool
                                    ? const Text("1 kg")
                                    : InkWell(
                                  onTap: () {}, // Prevent propagation to parent
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    height: 25,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "1 kg",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action Button
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: Padding(
                          padding: isBool
                              ? const EdgeInsets.only(left: 15, right: 15)
                              : const EdgeInsets.symmetric(horizontal: 15, vertical: 32),
                          child: isBool
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: onDelete,
                                child: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          )
                              : isInCart
                              ? Count(
                            productPrice: productPrice,
                            productImage: productImage,
                            productName: productName,
                            productId: productId,
                          )
                              : Container(
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {
                                reviewCartProvider.addReviewCartData(
                                  cartImage: productImage,
                                  cartName: productName,
                                  cartId: productId,
                                  cartPrice: productPrice,
                                  cartQuantity: 1,
                                );
                              },
                              child: const Center(
                                child: Text(
                                  "ADD",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              isBool ? const Divider(height: 1, color: Colors.black45) : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}