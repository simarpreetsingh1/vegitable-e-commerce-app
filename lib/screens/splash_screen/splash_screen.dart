import 'package:flutter/material.dart';
import 'package:restaurant/auth/sign_in.dart';

// Add this import for your HomeScreen (replace with actual import path)
import 'package:restaurant/screens/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 5 seconds then navigate to home screen
    Future.delayed(Duration(seconds: 3), () {
      // Use pushReplacement to remove splash screen from navigation stack
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/splash.png',
          fit: BoxFit.cover,
          // Add error builder to handle missing images gracefully
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error, size: 100, color: Colors.red);
          },
        ),
      ),
    );
  }
}