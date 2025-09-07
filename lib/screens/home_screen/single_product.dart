import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/reviewcart_provider.dart';
import 'package:restaurant/screens/home_screen/search/count.dart';

class SingleProduct extends StatelessWidget {
  final String productImage;
  final String productName;
  final int productPrice;
  final String unit;
  final VoidCallback onTap;
  final String productId;
  final VoidCallback? onCartPressed;

  const SingleProduct({
    required this.productImage,
    required this.productName,
    required this.productPrice,
    this.unit = 'kg',
    required this.onTap,
    required this.productId,
    this.onCartPressed,
    Key? key,
  }) : super(key: key);

  // void _showWeightOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           ListTile(
  //             title: const Text('1 kg'),
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           ListTile(
  //             title: const Text('2 kg'),
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           ListTile(
  //             title: const Text('3 Kg'),
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewCartProvider>(
      builder: (context, reviewCartProvider, child) {
        final isInCart = reviewCartProvider.isProductInCart(productId);

        return Container(
          margin: EdgeInsets.only(right: 10),
          height: 230,
          width: 165,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 150,
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  child: Image.network(
                    productImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "₹$productPrice/$unit",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      // Fixed Row layout with proper constraints
                      Container(
                        height: 25,
                        child: Row(
                          children: [
                            // Weight selector - fixed width
                            Container(
                              width: 60, // Fixed width instead of Expanded
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Center(
                                          child: Text(
                                            "1 kg",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Icon(Icons.arrow_drop_down, size: 18),
                                  ],
                                ),

                            ),
                            SizedBox(width: 8),
                            // Cart button/Count - fixed width
                            Container(
                              width: 70, // Fixed width instead of Expanded
                              child: isInCart
                                  ? Count(
                                productPrice: productPrice,
                                productImage: productImage,
                                productName: productName,
                                productId: productId,
                              )
                                  : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: InkWell(
                                  onTap: onCartPressed ?? () {
                                    reviewCartProvider.addReviewCartData(
                                      cartImage: productImage,
                                      cartName: productName,
                                      cartId: productId,
                                      cartPrice: productPrice,
                                      cartQuantity: 1,
                                    );
                                  },
                                  child: Center(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}