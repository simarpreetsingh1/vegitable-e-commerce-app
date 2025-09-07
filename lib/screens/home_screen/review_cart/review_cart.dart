import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/reviewcart_provider.dart';
import 'package:restaurant/screens/checkout/deliverydetails/deliverydetails.dart';
import 'package:restaurant/screens/home_screen/search/search_items.dart';
import 'package:restaurant/models/product_model.dart';
import 'package:restaurant/models/reviewcart_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReviewCart extends StatefulWidget {
  final List<ProductModel> search;

  const ReviewCart({
    Key? key,
    required this.search,
  }) : super(key: key);

  @override
  State<ReviewCart> createState() => _ReviewCartState();
}

class _ReviewCartState extends State<ReviewCart> {
  late ReviewCartProvider reviewCartProvider;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    reviewCartProvider = Provider.of<ReviewCartProvider>(context, listen: false);
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    await reviewCartProvider.getReviewCartData();
    _calculateTotal();
  }

  void _calculateTotal() {
    setState(() {
      totalAmount = reviewCartProvider.getReviewCartDataList.fold(
          0.0,
              (sum, item) => sum + (item.cartPrice * item.cartQuantity)
      );
    });
  }

  void showAlertDialog(BuildContext context, ReviewCartModel delete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cart Product"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await reviewCartProvider.reviewCartDataDelete(delete.cartId);
                _calculateTotal(); // Just recalculate total, no need to reload all data
                if (mounted) Navigator.of(context).pop();
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
        title: const Text("Review Cart"),
      ),
      body: Consumer<ReviewCartProvider>(
        builder: (context, reviewCartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: reviewCartProvider.getReviewCartDataList.isEmpty
                    ? const Center(child: Text("Bucket is Empty"))
                    : ListView.builder(
                  itemCount: reviewCartProvider.getReviewCartDataList.length,
                  itemBuilder: (context, index) {
                    ReviewCartModel data = reviewCartProvider.getReviewCartDataList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: SearchItems(
                        isBool: true,
                        productImage: data.cartImage,
                        productName: data.cartName,
                        productPrice: data.cartPrice,
                        productId: data.cartId,
                        productQuantity: data.cartQuantity,
                        onDelete: () => showAlertDialog(context, data),
                      ),
                    );
                  },
                ),
              ),
              _buildBottomNavigationBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total Amount"),
              Text(
                "₹${totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if(reviewCartProvider.getReviewCartDataList.isEmpty){
                Fluttertoast.showToast(msg: "No Cart Data Found"); // REMOVED THE 'return' KEYWORD
                return; // ADDED A SEPARATE return STATEMENT
              }
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Deliverydetails(),),);
            },
            child: Text("Submit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}