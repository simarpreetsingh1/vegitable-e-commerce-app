import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaurant/auth/sign_in.dart';
import 'package:restaurant/provider/checkout_provider.dart';
import 'package:restaurant/provider/product_provider.dart';
import 'package:restaurant/provider/wishlist_provider.dart';
import 'package:restaurant/provider/checkout_provider.dart';
import 'package:restaurant/provider/reviewcart_provider.dart';
import 'package:restaurant/provider/user_provider.dart';
import 'package:restaurant/screens/checkout/deliverydetails/deliverydetails.dart';
import 'package:restaurant/screens/home_screen/home_screen.dart';
import 'package:restaurant/screens/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ReviewCartProvider>(
          create: (context) => ReviewCartProvider(),
        ),
        ChangeNotifierProvider<WishlistProvider>(
        create: (context) => WishlistProvider(),
        ),
        ChangeNotifierProvider<CheckoutProvider>(
          create: (context) => CheckoutProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: HomeScreen(),
      ),
    );
  }
}