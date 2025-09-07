import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant/models/product_model.dart';

class WishlistProvider with ChangeNotifier {
  Future<void> addWishlistData({
    required String wishlistImage,
    required String wishlistName,
    required String wishlistId,
    required int wishlistPrice,
    required int wishlistQuantity,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("WishList")
        .doc(user.uid)  // Use the local user variable
        .collection("YourWishList")
        .doc(wishlistId)
        .set({
      "wishlistName": wishlistName,
      "wishlistPrice": wishlistPrice,
      "wishlistImage": wishlistImage,
      "wishlistId": wishlistId,
      "wishlistQuantity": wishlistQuantity,
      "wishlist": true,
    });
  }

  List<ProductModel> wishList = [];

  Future<void> getWishListData() async {
    List<ProductModel> newList = [];
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot value = await FirebaseFirestore.instance
        .collection("WishList")
        .doc(user.uid)
        .collection("YourWishList")
        .get();

    for (var element in value.docs) {
      ProductModel productModel = ProductModel(
        productImage: element.get("wishlistImage"),
        productName: element.get("wishlistName"),
        productPrice: element.get("wishlistPrice"),
        productId: element.get("wishlistId"),
        productQuantity: element.get("wishlistQuantity"),
        productDescription: element.get("wishlistDescription"),
      );
      newList.add(productModel);
    }

    wishList = newList;
    notifyListeners();
  }

  List<ProductModel> get getWishList {
    return wishList;
  }

  Future<void> deleteWishList(String wishListId) async {  // Added parameter
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("WishList")
        .doc(user.uid)
        .collection("YourWishList")
        .doc(wishListId)  // Use the passed parameter
        .delete();

    // Remove from local list and notify listeners
    wishList.removeWhere((item) => item.productId == wishListId);
    notifyListeners();
  }
}