import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/deliveryaddress_model.dart';
import 'package:restaurant/provider/checkout_provider.dart';
import 'package:restaurant/screens/checkout/add_delivery_address/add_delivery_address.dart';
import 'package:restaurant/screens/checkout/deliverydetails/single_deliveryitem.dart';
import 'package:restaurant/screens/checkout/payment_summary/payment_summary.dart';

class Deliverydetails extends StatefulWidget {
  @override
  _DeliverydetailsState createState() => _DeliverydetailsState();
}

class _DeliverydetailsState extends State<Deliverydetails> {
  // Initialize the value with a default DeliveryAddressModel
  DeliveryAddressModel value = DeliveryAddressModel(
    firstName: "",
    lastName: "",
    mobileNumber: "",
    alternativeNumber: "",
    society: "",
    street: "",
    landmark: "",
    city: "",
    area: "",
    pinCode: "",
    addressType: "",
    longitude: 0.0, // Add this
    latitude: 0.0,  // Add this
  );

  @override
  void initState() {
    super.initState();
    // Load delivery address data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CheckoutProvider>(context, listen: false).getDeliveryAddressData();
    });
  }

  @override
  Widget build(BuildContext context) {
    CheckoutProvider deliveryAddressProvider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Delivery Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () async {
            // Use await to wait for the result from AddDeliveryAddress
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddDeliveryAddress()),
            );

            // If a new address was added, refresh the data
            if (result == true) {
              deliveryAddressProvider.getDeliveryAddressData();
            }
          }
      ),
      bottomNavigationBar: Container(
        height: 45,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: MaterialButton(
          child: deliveryAddressProvider.getDeliveryAddressList.isEmpty
              ? Text("Add New Address")
              : Text("Payment Summary"),
          onPressed: () {
            deliveryAddressProvider.getDeliveryAddressList.isEmpty
                ? Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddDeliveryAddress(),
            )).then((result) {
              if (result == true) {
                deliveryAddressProvider.getDeliveryAddressData();
              }
            })
                : Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaymentSummary(
                  deliveryAddressList: value
              ),
            ));
          },
          color: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Deliver To"),
            leading: Image.asset(
              "assets/location.png",
              height: 40,
            ),
          ),
          Divider(
            height: 1,
          ),
          deliveryAddressProvider.getDeliveryAddressList.isEmpty
              ? Container(
            height: 200,
            child: Center(
              child: Text(
                "No Delivery Address Added",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ),
          )
              : Column(
            children: deliveryAddressProvider.getDeliveryAddressList.map((e) {
              setState(() {
                value = e;
              });
              return SingleDeliveryitem(
                title: "${e.firstName} ${e.lastName}",
                addressType: e.addressType == "AddressTypes.Other"
                    ? "Other"
                    : e.addressType == "AddressTypes.Home"
                    ? "Home"
                    : "Work",
                address: "${e.area}, ${e.street}, ${e.society}, ${e.city} - ${e.pinCode}",
                number: e.mobileNumber,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}