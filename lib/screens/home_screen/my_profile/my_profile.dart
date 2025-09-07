import 'package:flutter/material.dart';
import 'package:restaurant/screens/checkout/add_delivery_address/add_delivery_address.dart';
import 'package:restaurant/screens/checkout/deliverydetails/deliverydetails.dart';
import 'package:restaurant/screens/home_screen/contact_support/contact_support.dart';
import 'package:restaurant/screens/home_screen/drawer_side.dart';
import 'package:restaurant/models/user_model.dart';
import 'package:restaurant/provider/user_provider.dart';
import 'package:restaurant/auth/sign_in.dart';
import 'package:restaurant/screens/home_screen/review_cart/review_cart.dart'; // Import for navigation

class MyProfile extends StatefulWidget {
  final UserModel userData;
  final UserProvider userProvider;
  const MyProfile({required this.userData, required this.userProvider, super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Widget listTile({required IconData icon, required String title, VoidCallback? onTap}) {
    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ],
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
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: const Text(
          "My Profile",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      drawer: DrawerSide(userProvider: widget.userProvider),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                color: Colors.green,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 370,
                            height: 120,
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.userData.userName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(widget.userData.userEmail),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      listTile(
                        icon: Icons.shop_outlined,
                        title: "My Orders",
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ReviewCart(search: [],),),
                          );
                        }
                      ),
                      listTile(
                        icon: Icons.location_on_outlined,
                        title: "My Delivery Address",
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Deliverydetails(),),
                            );
                          }
                      ),
                      listTile(
                        icon: Icons.person_outline,
                        title: "Refer A Friends",
                      ),
                      listTile(
                        icon: Icons.location_on_outlined,
                        title: "Add New Address",
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => AddDeliveryAddress(),),
                            );
                          }
                      ),
                      listTile(
                        icon: Icons.help_outline,
                        title: "Help Center",
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ContactSupport(),),
                            );
                          }
                      ),
                      listTile(
                        icon: Icons.exit_to_app_outlined,
                        title: "Log out",
                        onTap: _showLogoutDialog,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 30),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.yellow,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.userData.userImage ??
                    "https://s3.envato.com/files/328957910/vegi_thumb.png"),
                radius: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}