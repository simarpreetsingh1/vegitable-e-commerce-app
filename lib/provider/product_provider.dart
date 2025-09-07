import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> herbsProductList = [];
  List<ProductModel> freshFruitsProductList = [];
  List<ProductModel> rootVegetableProductList = [];

  Future<void> fetchHerbsProductData() async {
    try {
      List<ProductModel> newList = [];
      QuerySnapshot value =
      await FirebaseFirestore.instance.collection("HerbsProduct").get();

      for (var element in value.docs) {
        final data = element.data() as Map<String, dynamic>? ?? {};
        final product = _createProductModel(data, element.id);
        if (product != null) {
          newList.add(product);
        }
      }
      herbsProductList = newList;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching herbs products: $e");
    }
  }

  Future<void> fetchFreshFruitsProductData() async {
    try {
      List<ProductModel> newList = [];
      QuerySnapshot value =
      await FirebaseFirestore.instance.collection("FreshFruits").get();

      for (var element in value.docs) {
        final data = element.data() as Map<String, dynamic>? ?? {};
        final product = _createProductModel(data, element.id);
        if (product != null) {
          newList.add(product);
        }
      }
      freshFruitsProductList = newList;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching fresh fruits products: $e");
    }
  }

  Future<void> fetchRootVegetableProductData() async {
    try {
      List<ProductModel> newList = [];
      QuerySnapshot value =
      await FirebaseFirestore.instance.collection("RootVegetable").get();

      for (var element in value.docs) {
        final data = element.data() as Map<String, dynamic>? ?? {};
        final product = _createProductModel(data, element.id);
        if (product != null) {
          newList.add(product);
        }
      }
      rootVegetableProductList = newList;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching root vegetable products: $e");
    }
  }

  ProductModel? _createProductModel(Map<String, dynamic> data, String docId) {
    try {
      dynamic price = data['productPrice'];
      final productPrice = (price is int)
          ? price
          : (price is double)
          ? price.toInt()
          : 0;

      return ProductModel(
        productImage: data['productImage']?.toString() ?? '',
        productName: data['productName']?.toString() ?? '',
        productPrice: productPrice,
        productQuantity: data['productQuantity'] ?? 0,
        productId: data['productId']?.toString() ?? docId, // Use docId as fallback
        productDescription: data['productDescription']?.toString() ?? '',
      );
    } catch (e) {
      debugPrint("Error creating product model: $e");
      return null;
    }
  }

  // Getters remain the same...
  List<ProductModel> get getHerbsProductDataList => herbsProductList;
  List<ProductModel> get getFreshFruitsProductDataList => freshFruitsProductList;
  List<ProductModel> get getRootVegetableProductDataList => rootVegetableProductList;
  List<ProductModel> get allProducts => [...herbsProductList, ...freshFruitsProductList, ...rootVegetableProductList];

  Future<void> fetchAllProducts() async {
    await Future.wait([
      fetchHerbsProductData(),
      fetchFreshFruitsProductData(),
      fetchRootVegetableProductData(),
    ]);
  }
}