import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? currentData; // Make it nullable with ?

  Future<void> addUserData({
    required User currentUser,
    required String userName,
    required String userEmail,
    required String userImage,
  }) async {
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(currentUser.uid)
        .set({
      "userName": userName,
      "userEmail": userEmail,
      "userImage": userImage,
      "userUid": currentUser.uid,
    });
    notifyListeners();
  }

  Future<void> getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    var value = await FirebaseFirestore.instance
        .collection("userData")
        .doc(currentUser.uid)
        .get();

    if (value.exists) {
      final userModel = UserModel(
        userImage: value.get("userImage"),
        userName: value.get("userName"),
        userEmail: value.get("userEmail"),
        userUid: value.get("userUid"),
      );
      currentData = userModel;
      notifyListeners();
    }
  }

  UserModel? get currentUserData {
    return currentData;
  }
}