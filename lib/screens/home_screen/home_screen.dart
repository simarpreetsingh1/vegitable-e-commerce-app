import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/product_model.dart';
import 'package:restaurant/provider/product_provider.dart';
import 'package:restaurant/provider/reviewcart_provider.dart';
import 'package:restaurant/provider/user_provider.dart';
import 'package:restaurant/screens/home_screen/drawer_side.dart';
import 'package:restaurant/screens/home_screen/product_overview/product_overview.dart';
import 'package:restaurant/screens/home_screen/review_cart/review_cart.dart';
import 'package:restaurant/screens/home_screen/search/search.dart';
import 'package:restaurant/screens/home_screen/single_product.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final reviewCartProvider = Provider.of<ReviewCartProvider>(context, listen: false);

    try {
      await Future.wait([
        productProvider.fetchHerbsProductData(),
        productProvider.fetchFreshFruitsProductData(),
        productProvider.fetchRootVegetableProductData(),
        reviewCartProvider.getReviewCartData(),
      ]);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();

    return Scaffold(
      backgroundColor: Colors.grey[350],
      drawer: DrawerSide(userProvider: userProvider),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Home", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.green,
        actions: [
          // Search Icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white54,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Search(
                        search: productProvider.allProducts,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.search, size: 18, color: Colors.black),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),
          ),
          // Shopping Cart Icon with badge - Now properly listening to changes
          Consumer<ReviewCartProvider>(
            builder: (context, reviewCartProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white54,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ReviewCart(search: []),
                            ),
                          );
                        },
                        icon: Icon(Icons.shopping_cart, size: 18, color: Colors.black),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                    if (reviewCartProvider.cartItemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${reviewCartProvider.cartItemCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://www.baltana.com/files/wallpapers-24/Vegetable-High-Definition-Wallpaper-62234.jpg"),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 120, bottom: 10),
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                ),
                              ),
                              child: Center(
                                child: Text("Vegi",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                          Text("30% off",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.green.shade500,
                                    offset: const Offset(3, 3),
                                  ),
                                ],
                              )),
                          Text("On All Vegetables Products",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
            _buildProductSection(
              title: "Herbs Seasonings",
              productList: productProvider.getHerbsProductDataList,
              onViewAll: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Search(
                    search: productProvider.getHerbsProductDataList,
                  ),
                ),
              ),
            ),
            _buildProductSection(
              title: "Fresh Fruits",
              productList: productProvider.getFreshFruitsProductDataList,
              onViewAll: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Search(
                    search: productProvider.getFreshFruitsProductDataList,
                  ),
                ),
              ),
            ),
            _buildProductSection(
              title: "Root Vegetable",
              productList: productProvider.getRootVegetableProductDataList,
              onViewAll: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Search(
                    search: productProvider.getRootVegetableProductDataList,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSection({
    required String title,
    required List<ProductModel> productList,
    required VoidCallback onViewAll,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: onViewAll,
                child: Text("View all", style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: productList.isEmpty
              ? Center(child: Text("No products available"))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return Consumer<ReviewCartProvider>(
                builder: (context, reviewCartProvider, child) {
                  final isInCart = reviewCartProvider.isProductInCart(product.productId);

                  return SingleProduct(
                    productImage: product.productImage,
                    productName: product.productName,
                    productPrice: product.productPrice,
                    productId: product.productId,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductOverview(
                            productId: product.productId,
                            productName: product.productName,
                            productImage: product.productImage,
                            productPrice: product.productPrice,
                            productQuantity: product.productQuantity,
                            productDescription: product.productDescription,
                          ),
                        ),
                      );
                    },
                    onCartPressed: () {
                      if (isInCart) {
                        // Find and remove from cart
                        final cartItem = reviewCartProvider
                            .getReviewCartDataList
                            .firstWhere((item) => item.cartId == product.productId);
                        reviewCartProvider.reviewCartDataDelete(cartItem.cartId);
                      } else {
                        // Add to cart
                        reviewCartProvider.addReviewCartData(
                          cartImage: product.productImage,
                          cartName: product.productName,
                          cartId: product.productId,
                          cartPrice: product.productPrice.toInt(),
                          cartQuantity: 1,
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}