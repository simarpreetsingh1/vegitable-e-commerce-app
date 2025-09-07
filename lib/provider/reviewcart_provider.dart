import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant/models/reviewcart_model.dart';

class ReviewCartProvider extends ChangeNotifier {
  List<ReviewCartModel> _reviewCartDataList = [];
  bool _isLoading = false;

  List<ReviewCartModel> get getReviewCartDataList => _reviewCartDataList;
  bool get isLoading => _isLoading;

  // Check if a product is in cart
  bool isProductInCart(String productId) {
    return _reviewCartDataList.any((item) => item.cartId == productId);
  }

  // Get cart item count
  int get cartItemCount => _reviewCartDataList.length;

  // Get total cart amount
  double get totalAmount {
    return _reviewCartDataList.fold(
      0.0,
          (sum, item) => sum + (item.cartPrice * item.cartQuantity),
    );
  }

  Future<void> addReviewCartData({
    required String cartImage,
    required String cartName,
    required String cartId,
    required int cartPrice,
    required int cartQuantity,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection("ReviewCart")
          .doc(user.uid)
          .collection("YourReviewCart")
          .doc(cartId)
          .set({
        "cartName": cartName,
        "cartPrice": cartPrice,
        "cartImage": cartImage,
        "cartId": cartId,
        "cartQuantity": cartQuantity,
        "isAdd": true,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // Add to local list
      _reviewCartDataList.add(ReviewCartModel(
        cartImage: cartImage,
        cartName: cartName,
        cartId: cartId,
        cartPrice: cartPrice,
        cartQuantity: cartQuantity,
      ));

    } catch (e) {
      debugPrint("Error adding to cart: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getReviewCartData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _reviewCartDataList = [];
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      List<ReviewCartModel> newList = [];
      QuerySnapshot reviewCartValue = await FirebaseFirestore.instance
          .collection("ReviewCart")
          .doc(user.uid)
          .collection("YourReviewCart")
          .orderBy("createdAt", descending: true)
          .get();

      reviewCartValue.docs.forEach((element) {
        ReviewCartModel reviewCartModel = ReviewCartModel(
          cartImage: element.get("cartImage") ?? '',
          cartName: element.get("cartName") ?? '',
          cartId: element.get("cartId") ?? '',
          cartPrice: (element.get("cartPrice") as num?)?.toInt() ?? 0,
          cartQuantity: (element.get("cartQuantity") as num?)?.toInt() ?? 0,
        );
        newList.add(reviewCartModel);
      });

      _reviewCartDataList = newList;

    } catch (e) {
      debugPrint("Error fetching review cart data: $e");
      _reviewCartDataList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateReviewCartData({
    required String cartId,
    required int cartQuantity,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection("ReviewCart")
          .doc(user.uid)
          .collection("YourReviewCart")
          .doc(cartId)
          .update({
        "cartQuantity": cartQuantity,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      // Update local list
      final index = _reviewCartDataList.indexWhere((item) => item.cartId == cartId);
      if (index != -1) {
        _reviewCartDataList[index] = _reviewCartDataList[index].copyWith(
          cartQuantity: cartQuantity,
        );
      }

    } catch (e) {
      debugPrint("Error updating cart data: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reviewCartDataDelete(String cartId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection("ReviewCart")
          .doc(user.uid)
          .collection("YourReviewCart")
          .doc(cartId)
          .delete();

      // Remove from local list
      _reviewCartDataList.removeWhere((item) => item.cartId == cartId);

    } catch (e) {
      debugPrint("Error deleting cart item: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners(); // This will update all listeners
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Delete all documents in the user's cart collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection("ReviewCart")
          .doc(user.uid)
          .collection("YourReviewCart")
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      _reviewCartDataList.clear();

    } catch (e) {
      debugPrint("Error clearing cart: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}