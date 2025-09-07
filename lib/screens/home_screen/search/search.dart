import 'package:flutter/material.dart';
import 'package:restaurant/models/product_model.dart';
import 'package:restaurant/screens/home_screen/product_overview/product_overview.dart';
import 'package:restaurant/screens/home_screen/search/search_items.dart';
import 'package:restaurant/screens/home_screen/product_overview/product_overview.dart'; // Import your product overview page

class Search extends StatefulWidget {
  final List<ProductModel> search;
  const Search({required this.search, Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = "";
  late List<ProductModel> _searchResults;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchResults = widget.search;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      query = _searchController.text.toLowerCase();
      _searchResults = widget.search.where((ProductModel element) {
        return element.productName.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Navigation method to product overview
  void _navigateToProductOverview(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductOverview(
          productName: product.productName,
          productImage: product.productImage,
          productPrice: product.productPrice,
          productId: product.productId,
          productQuantity: product.productQuantity,
          productDescription: product.productDescription, // Add this line
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Search Product"),
      ),
      body: Column(
        children: [
          const ListTile(
            title: Text("Items"),
          ),
          Container(
            height: 62,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[500],
                filled: true,
                hintText: "Search for items in the store",
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(
              child: Text(
                "No items found",
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final ProductModel data = _searchResults[index];
                return SearchItems(
                  isBool: false,
                  productImage: data.productImage,
                  productName: data.productName,
                  productPrice: data.productPrice,
                  productId: data.productId,
                  productQuantity: data.productQuantity,
                  onDelete: () {},
                  onTap: () => _navigateToProductOverview(data), // Add onTap callback
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}