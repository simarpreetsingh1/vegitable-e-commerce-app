import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restaurant/screens/home_screen/home_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:restaurant/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late UserProvider userProvider;
  bool _isLoading = false;

  Future<void> _googleSignUp() async {
    setState(() => _isLoading = true);

    try {
      final googleSignIn = GoogleSignIn();
      final auth = FirebaseAuth.instance;

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await userProvider.addUserData(
          currentUser: user,
          userName: user.displayName ?? '',
          userEmail: user.email ?? '',
          userImage: user.photoURL ?? '',
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _appleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final auth = FirebaseAuth.instance;

      // Trigger Apple Sign-In flow
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create Firebase credential from Apple response
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with Apple credentials
      final userCredential = await auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (user != null) {
        await userProvider.addUserData(
          currentUser: user,
          userName: user.displayName ?? 'Apple User',
          userEmail: user.email ?? '',
          userImage: user.photoURL ?? '',
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Apple Sign-In failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Background Image
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/background.jpg"),
                ),
              ),
            ),

            // Content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign in to continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Vegi",
                          style: TextStyle(
                            fontSize: 70,
                            color: Colors.green,
                            shadows: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.green.shade500,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            _isLoading
                                ? const CircularProgressIndicator()
                                : SignInButton(
                              Buttons.Google,
                              text: "Continue with Google",
                              onPressed: _googleSignUp,
                            ),
                            const SizedBox(height: 6),
                            SignInButton(
                              Buttons.Apple,
                              text: "Continue with Apple",
                              onPressed: _appleSignIn,
                            ),
                          ],
                        ),
                        const Column(
                          children: [
                            Text(
                              "By signing in you are agreeing to our",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Terms and Privacy Policy",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}