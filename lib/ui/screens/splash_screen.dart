import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/screens/auth/check_if_logged_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    navigateToLogin();
  }

  Future<void> navigateToLogin() async {
    Future.delayed(const Duration(seconds: 2)).then((_) async {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>const CheckIfLoggedIn()),(route) => false,
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
          ),
          child: Text(
            "Rokto Bondhu",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * .1,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
