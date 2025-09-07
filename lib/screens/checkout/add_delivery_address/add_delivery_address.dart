import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/checkout_provider.dart';
import 'package:restaurant/screens/checkout/google_map/google_map.dart';

class AddDeliveryAddress extends StatefulWidget {
  const AddDeliveryAddress({super.key});

  @override
  State<AddDeliveryAddress> createState() => _AddDeliveryAddressState();
}

enum AddressTypes {
  Home,
  Work,
  Other,
}

class _AddDeliveryAddressState extends State<AddDeliveryAddress> {
  AddressTypes myType = AddressTypes.Home;

  // Helper method to convert enum to string
  String _getAddressTypeString(AddressTypes type) {
    switch (type) {
      case AddressTypes.Home:
        return 'Home';
      case AddressTypes.Work:
        return 'Work';
      case AddressTypes.Other:
        return 'Other';
      default:
        return 'Home';
    }
  }

  // Custom TextField widget
  Widget CustomTextField({
    required String labText,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
  }) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Add Delivery Address",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 48,
        child: MaterialButton(
          onPressed: () async {
            // Call validator and wait for the result
            await checkoutProvider.validator(context, _getAddressTypeString(myType));

            // After validator completes (and pops the screen), return true to indicate success
            // The actual navigation pop happens in the validator method
          },
          color: Colors.green,
          child: const Text(
            "Add Address",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Personal Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              labText: "First Name",
              controller: checkoutProvider.firstName,
            ),
            CustomTextField(
              labText: "Last Name",
              controller: checkoutProvider.lastName,
            ),
            CustomTextField(
              labText: "Mobile Number",
              keyboardType: TextInputType.phone,
              controller: checkoutProvider.mobileNumber,
            ),
            CustomTextField(
              labText: "Alternate Mobile Number",
              keyboardType: TextInputType.phone,
              controller: checkoutProvider.alternativeMobileNumber,
            ),

            const SizedBox(height: 20),
            const Text(
              "Address Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              labText: "Society",
              controller: checkoutProvider.society,
            ),
            CustomTextField(
              labText: "Street",
              controller: checkoutProvider.street,
            ),
            CustomTextField(
              labText: "Landmark",
              controller: checkoutProvider.landmark,
            ),
            CustomTextField(
              labText: "City",
              controller: checkoutProvider.city,
            ),
            CustomTextField(
              labText: "Area",
              controller: checkoutProvider.area,
            ),
            CustomTextField(
              labText: "Pin Code",
              keyboardType: TextInputType.number,
              controller: checkoutProvider.pinCode,
            ),

            const SizedBox(height: 10),
            Consumer<CheckoutProvider>(
              builder: (context, provider, child) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CustomGoogleMap(),
                      ),
                    );
                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          provider.setLocation == null
                              ? "Set location"
                              : "Location selected",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Icon(
                          Icons.location_on,
                          color: provider.setLocation == null
                              ? Colors.grey
                              : Colors.green,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),
            const Divider(color: Colors.grey),

            const SizedBox(height: 10),
            const ListTile(
              title: Text(
                "Address Type*",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            RadioListTile(
              value: AddressTypes.Home,
              groupValue: myType,
              title: const Text("Home"),
              onChanged: (AddressTypes? value) {
                setState(() {
                  myType = value!;
                });
              },
              secondary: const Icon(Icons.home, color: Colors.green),
            ),
            RadioListTile(
              value: AddressTypes.Work,
              groupValue: myType,
              title: const Text("Work"),
              onChanged: (AddressTypes? value) {
                setState(() {
                  myType = value!;
                });
              },
              secondary: const Icon(Icons.work, color: Colors.blue),
            ),
            RadioListTile(
              value: AddressTypes.Other,
              groupValue: myType,
              title: const Text("Other"),
              onChanged: (AddressTypes? value) {
                setState(() {
                  myType = value!;
                });
              },
              secondary: const Icon(Icons.location_city, color: Colors.orange),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}