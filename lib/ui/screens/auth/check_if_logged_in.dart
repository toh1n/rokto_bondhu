
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/screens/auth/login_screen.dart';
import 'package:rokto_bondhu/ui/screens/base_screen.dart';

class CheckIfLoggedIn extends StatelessWidget {
  const CheckIfLoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const BaseScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}