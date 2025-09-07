import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:restaurant/models/deliveryaddress_model.dart';

class CheckoutProvider with ChangeNotifier {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController alternativeMobileNumber = TextEditingController();
  TextEditingController society = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  LocationData? setLocation;
  String addressType = '';

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    mobileNumber.dispose();
    alternativeMobileNumber.dispose();
    society.dispose();
    street.dispose();
    landmark.dispose();
    city.dispose();
    area.dispose();
    pinCode.dispose();
    super.dispose();
  }

  Future<void> validator(BuildContext context, String myType) async {
    if (firstName.text.isEmpty) {
      Fluttertoast.showToast(msg: "Firstname is Empty");
      return;
    } else if (lastName.text.isEmpty) {
      Fluttertoast.showToast(msg: "Lastname is Empty");
      return;
    } else if (mobileNumber.text.isEmpty) {
      Fluttertoast.showToast(msg: "Mobile is Empty");
      return;
    } else if (alternativeMobileNumber.text.isEmpty) {
      Fluttertoast.showToast(msg: "Alternative Mobile Number is Empty");
      return;
    } else if (society.text.isEmpty) {
      Fluttertoast.showToast(msg: "Society is Empty");
      return;
    } else if (street.text.isEmpty) {
      Fluttertoast.showToast(msg: "Street is Empty");
      return;
    } else if (landmark.text.isEmpty) {
      Fluttertoast.showToast(msg: "Landmark is Empty");
      return;
    } else if (city.text.isEmpty) {
      Fluttertoast.showToast(msg: "City is Empty");
      return;
    } else if (area.text.isEmpty) {
      Fluttertoast.showToast(msg: "Area is Empty");
      return;
    } else if (pinCode.text.isEmpty) {
      Fluttertoast.showToast(msg: "PinCode is Empty");
      return;
    } else if (setLocation == null) {
      Fluttertoast.showToast(msg: "Set Location is Empty");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("AddDeliveryAddress")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "firstName": firstName.text,
        "lastName": lastName.text,
        "mobileNumber": mobileNumber.text,
        "alternativeMobileNumber": alternativeMobileNumber.text,
        "society": society.text,
        "street": street.text,
        "landmark": landmark.text,
        "city": city.text,
        "area": area.text,
        "pinCode": pinCode.text,
        "addressType": myType,
        "longitude": setLocation!.longitude,
        "latitude": setLocation!.latitude,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "Added your delivery address successfully");

      // Clear the form after successful submission
      clearForm();

      // Pop the screen and return to indicate success
      Navigator.of(context).pop(true);

    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving address: ${e.toString()}");
      // Pop the screen and return to indicate failure
      Navigator.of(context).pop(false);
    }

    notifyListeners();
  }

  // Method to clear all form fields
  void clearForm() {
    firstName.clear();
    lastName.clear();
    mobileNumber.clear();
    alternativeMobileNumber.clear();
    society.clear();
    street.clear();
    landmark.clear();
    city.clear();
    area.clear();
    pinCode.clear();
    setLocation = null;
    addressType = '';
    notifyListeners();
  }

  List<DeliveryAddressModel> deliveryAddressList = [];

  Future<void> getDeliveryAddressData() async {
    List<DeliveryAddressModel> newList = [];

    try {
      DocumentSnapshot _db = await FirebaseFirestore.instance
          .collection("AddDeliveryAddress")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (_db.exists) {
        // Create a DeliveryAddressModel instance with proper parameter names
        DeliveryAddressModel deliveryAddressModel = DeliveryAddressModel(
          firstName: _db.get("firstName") ?? "",
          lastName: _db.get("lastName") ?? "",
          mobileNumber: _db.get("mobileNumber") ?? "",
          alternativeNumber: _db.get("alternativeMobileNumber") ?? "",
          society: _db.get("society") ?? "",
          street: _db.get("street") ?? "",
          landmark: _db.get("landmark") ?? "",
          city: _db.get("city") ?? "",
          area: _db.get("area") ?? "",
          pinCode: _db.get("pinCode") ?? "",
          addressType: _db.get("addressType") ?? "",
          longitude: _db.get("longitude") ?? 0.0, // Add this
          latitude: _db.get("latitude") ?? 0.0,   // Add this
        );

        newList.add(deliveryAddressModel);
      }

      deliveryAddressList = newList;
      notifyListeners();

    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching address: ${e.toString()}");
    }
  }

  List<DeliveryAddressModel> get getDeliveryAddressList {
    return deliveryAddressList;
  }
}