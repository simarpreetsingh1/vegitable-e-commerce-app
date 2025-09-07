import 'package:flutter/material.dart';
import 'package:restaurant/auth/sign_in.dart';
import 'package:restaurant/screens/checkout/payment_summary/payment_summary.dart';
import 'package:restaurant/screens/home_screen/contact_support/contact_support.dart';
import 'package:restaurant/screens/home_screen/home_screen.dart';
import 'package:restaurant/screens/home_screen/my_profile/my_profile.dart';
import 'package:restaurant/screens/home_screen/review_cart/review_cart.dart';
import 'package:restaurant/screens/wishlist/wishlist.dart';
import 'package:restaurant/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/checkout_provider.dart';
import 'package:restaurant/models/deliveryaddress_model.dart';

class DrawerSide extends StatefulWidget {
  final UserProvider userProvider;
  const DrawerSide({required this.userProvider});

  @override
  State<DrawerSide> createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  Widget listTile({
    required IconData icon,
    required String title,
    required VoidCallback onPress,
  }) {
    return ListTile(
      onTap: onPress,
      leading: Icon(icon, size: 32),
      title: Text(title, style: const TextStyle(color: Colors.black)),
    );
  }

  void _performLogout() {

    // Navigate to login screen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignIn()),
          (Route<dynamic> route) => false,
    );

    // Show logout confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Logged out successfully"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;
    return Drawer(
      child: Container(
        color: Colors.green[300],
        child: ListView(
          children: [
            DrawerHeader(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.yellow,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userData?.userImage ?? "https://s3.envato.com/files/328957910/vegi_thumb.png"),
                        radius: 45,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userData?.userName ?? "Guest User"),
                        Text(userData?.userEmail ?? "No email"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            listTile(
              icon: Icons.home_outlined,
              title: "Home",
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            listTile(
              icon: Icons.shopping_cart_outlined,
              title: "Review Cart",
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReviewCart(search: [])),
                );
              },
            ),
            listTile(
              icon: Icons.person_outlined,
              title: "My Profile",
              onPress: () {
                if (userData != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyProfile(
                      userData: userData,
                      userProvider: widget.userProvider,
                    )),
                  );
                }
              },
            ),
            listTile(
              icon: Icons.favorite_outline,
              title: "Wishlist",
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WishList(search: [])),
                );
              },
            ),
            listTile(
              icon: Icons.currency_rupee_outlined,
              title: "Payment Summary",
              onPress: () {
                // Get the delivery address from CheckoutProvider
                final checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

                // Check if there's a delivery address
                if (checkoutProvider.getDeliveryAddressList.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentSummary(
                        deliveryAddressList: checkoutProvider.getDeliveryAddressList.first,
                      ),
                    ),
                  );
                } else {
                  // Show a message if no address is available
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please add a delivery address first"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            listTile(
              icon: Icons.support_agent,
              title: "Contact Support",
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ContactSupport()),
                );
              },
            ),

            // Logout Section with visual separation
            const Divider(
              thickness: 1,
              color: Colors.black26,
              height: 20,
              indent: 20,
              endIndent: 20,
            ),

            ListTile(
              onTap: _showLogoutDialog,
              leading: const Icon(
                Icons.logout,
                size: 32,
                color: Colors.red,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}