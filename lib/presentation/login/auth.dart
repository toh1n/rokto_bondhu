import 'package:complete_advanced_flutter/presentation/login/is_phone_verified.dart';
import 'package:complete_advanced_flutter/presentation/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return IsEmailVerified();
          } else {
            return LoginView();
          }
        },
      ),
    );
  }
}
