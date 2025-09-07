import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/reviewcart_provider.dart';
import 'package:restaurant/provider/wishlist_provider.dart';
import 'package:restaurant/screens/home_screen/review_cart/review_cart.dart';
import 'package:restaurant/screens/home_screen/search/count.dart';

enum SigninCharacter { fill, outline }

class ProductOverview extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;
  final int productQuantity;
  final String productDescription;

  const ProductOverview({
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productQuantity,
    required this.productId,
    required this.productDescription,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  late ReviewCartProvider reviewCartProvider;
  late WishlistProvider wishlistProvider;
  SigninCharacter _character = SigninCharacter.fill;
  bool _isLoading = true;
  bool _wishListBool = false;

  @override
  void initState() {
    super.initState();
    reviewCartProvider = Provider.of<ReviewCartProvider>(context, listen: false);
    wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    _loadCartData();
    _checkWishlistStatus();
  }

  Future<void> _loadCartData() async {
    await reviewCartProvider.getReviewCartData();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkWishlistStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection("WishList")
            .doc(user.uid)
            .collection("YourWishList")
            .doc(widget.productId)
            .get();

        if (mounted) {
          setState(() {
            _wishListBool = doc.exists;
          });
        }
      } catch (e) {
        debugPrint("Error checking wishlist: $e");
      }
    }
  }

  Widget bottomNavigatorBar({
    required Color iconColor,
    required Color backgroundColor,
    required Color color,
    required String title,
    required IconData iconData,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(20),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 20, color: iconColor),
              const SizedBox(width: 5),
              Text(title, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleWishlist() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (_wishListBool) {
        await wishlistProvider.deleteWishList(widget.productId);
        if (mounted) {
          setState(() => _wishListBool = false);
        }
      } else {
        await wishlistProvider.addWishlistData(
          wishlistImage: widget.productImage,
          wishlistName: widget.productName,
          wishlistId: widget.productId,
          wishlistPrice: widget.productPrice,
          wishlistQuantity: widget.productQuantity,
        );
        if (mounted) {
          setState(() => _wishListBool = true);
        }
      }
    } catch (e) {
      debugPrint("Error toggling wishlist: $e");
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update wishlist')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        children: [
          bottomNavigatorBar(
            backgroundColor: Colors.black,
            color: Colors.white,
            iconColor: Colors.grey,
            title: "Add To Wishlist",
            iconData: _wishListBool ? Icons.favorite : Icons.favorite_outline,
            onPressed: _toggleWishlist,
          ),
          bottomNavigatorBar(
            color: Colors.black,
            backgroundColor: Colors.green,
            iconColor: Colors.white,
            title: "Go to Cart",
            iconData: Icons.shopping_cart,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ReviewCart(search: []),
                ),
              );
            },
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Product Overview",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          ListTile(
            title: Text(
              widget.productName,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("₹${widget.productPrice}"),
          ),
          Container(
            height: 250,
            padding: const EdgeInsets.all(40),
            child: Image.network(
              widget.productImage,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error_outline, size: 50),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Available Options",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: Colors.green,
                    ),
                    Radio<SigninCharacter>(
                      value: SigninCharacter.fill,
                      groupValue: _character,
                      activeColor: Colors.green,
                      onChanged: (SigninCharacter? value) {
                        setState(() {
                          _character = value!;
                        });
                      },
                    ),
                  ],
                ),
                Text("₹${widget.productPrice}/kg"),
                Consumer<ReviewCartProvider>(
                  builder: (context, reviewCartProvider, child) {
                    final isInCart = reviewCartProvider.isProductInCart(widget.productId);

                    return Container(
                      height: 35,
                      width: 70,
                      child: isInCart
                          ? Count(
                        productPrice: widget.productPrice,
                        productImage: widget.productImage,
                        productName: widget.productName,
                        productId: widget.productId,
                      )
                          : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            reviewCartProvider.addReviewCartData(
                              cartImage: widget.productImage,
                              cartName: widget.productName,
                              cartId: widget.productId,
                              cartPrice: widget.productPrice,
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
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.productDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}