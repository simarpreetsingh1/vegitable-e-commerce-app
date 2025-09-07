import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/deliveryaddress_model.dart';
import 'package:restaurant/provider/reviewcart_provider.dart';
import 'package:restaurant/screens/checkout/payment_summary/order_items.dart';
import 'package:restaurant/screens/checkout/deliverydetails/single_deliveryitem.dart';

class PaymentSummary extends StatefulWidget {
  final DeliveryAddressModel deliveryAddressList;
  PaymentSummary({required this.deliveryAddressList});

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

enum AddressTypes {
  CashOnDelivery,
  Online,
}

class _PaymentSummaryState extends State<PaymentSummary> {
  var myType = AddressTypes.CashOnDelivery;
  double subTotal = 0.0;
  double totalAmount = 0.0;
  double shippingCharge = 0.0;
  double couponDiscount = 10.0; // Example discount

  @override
  void initState() {
    super.initState();
    // Calculate totals when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    final reviewCartProvider = Provider.of<ReviewCartProvider>(context, listen: false);

    // Calculate subtotal
    double calculatedSubTotal = reviewCartProvider.getReviewCartDataList.fold(
        0.0,
            (sum, item) => sum + (item.cartPrice * item.cartQuantity)
    );

    // Calculate total amount
    double calculatedTotal = calculatedSubTotal + shippingCharge - couponDiscount;

    setState(() {
      subTotal = calculatedSubTotal;
      totalAmount = calculatedTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    ReviewCartProvider reviewCartProvider = Provider.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Payment Summary",
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: ListTile(
        title: const Text("Total Amount"),
        subtitle: Text(
          "₹${totalAmount.toStringAsFixed(2)}",
          style: TextStyle(
            color: Colors.green[500],
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        trailing: Container(
          width: 160,
          child: MaterialButton(
            onPressed: () {},
            child: const Text(
              "Place Order",
              style: TextStyle(color: Colors.black),
            ),
            color: Colors.green[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView(
          children: [
            // Delivery Address Section
            SingleDeliveryitem(
              title: "${widget.deliveryAddressList.firstName} ${widget.deliveryAddressList.lastName}",
              addressType: widget.deliveryAddressList.addressType == "AddressTypes.Other"
                  ? "Other"
                  : widget.deliveryAddressList.addressType == "AddressTypes.Home"
                  ? "Home"
                  : "Work",
              address: "${widget.deliveryAddressList.area}, ${widget.deliveryAddressList.street}, ${widget.deliveryAddressList.society}, ${widget.deliveryAddressList.city} - ${widget.deliveryAddressList.pinCode}",
              number: widget.deliveryAddressList.mobileNumber,
            ),
            const Divider(),
            ExpansionTile(
              title: Text("Order Items ${reviewCartProvider.getReviewCartDataList.length}"),
              children: reviewCartProvider.getReviewCartDataList.map((e){
                return OrderItems(e: e);
              }).toList(),
            ),
            const Divider(),
            ListTile(
              minVerticalPadding: 5,
              leading: const Text(
                "Sub Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "₹${subTotal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              minVerticalPadding: 5,
              leading: const Text(
                "Shipping Charges",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "₹${shippingCharge.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              minVerticalPadding: 5,
              leading: const Text(
                "Coupon Discount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "-₹${couponDiscount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              minVerticalPadding: 5,
              leading: const Text(
                "Total Amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: Text(
                "₹${totalAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green[700],
                ),
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Text(
                "Payment Option",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            RadioListTile(
              value: AddressTypes.CashOnDelivery,
              groupValue: myType,
              title: const Text("Cash On Delivery"),
              onChanged: (AddressTypes? value) {
                setState(() {
                  myType = value!;
                });
              },
              secondary: const Icon(Icons.money, color: Colors.black),
            ),
            RadioListTile(
              value: AddressTypes.Online,
              groupValue: myType,
              title: const Text("Online"),
              onChanged: (AddressTypes? value) {
                setState(() {
                  myType = value!;
                });
              },
              secondary: const Icon(Icons.credit_card, color: Colors.black),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}