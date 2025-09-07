import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/wishlist_provider.dart';
import 'package:restaurant/screens/home_screen/search/search_items.dart';
import 'package:restaurant/models/product_model.dart';

class WishList extends StatefulWidget {
  final List<ProductModel> search;

  const WishList({
    Key? key,
    required this.search,
  }) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  late WishlistProvider wishlistProvider;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    await wishlistProvider.getWishListData();
  }

  void showAlertDialog(BuildContext context, ProductModel delete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Wishlist Product"),
          content: const Text("Are you sure you want to delete this item from wishlist?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await wishlistProvider.deleteWishList(delete.productId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: const Text("Wishlist"),
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          return Column(
            children: [
              Expanded(
                child: wishlistProvider.getWishList.isEmpty
                    ? const Center(child: Text("Wishlist is Empty"))
                    : ListView.builder(
                  itemCount: wishlistProvider.getWishList.length,
                  itemBuilder: (context, index) {
                    ProductModel data = wishlistProvider.getWishList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: SearchItems(
                        isBool: true,
                        productImage: data.productImage,
                        productName: data.productName,
                        productPrice: data.productPrice,
                        productId: data.productId,
                        productQuantity: data.productQuantity,
                        onDelete: () {
                          showAlertDialog(context, data); // Fixed: Using showAlertDialog instead of showAboutDialog
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}