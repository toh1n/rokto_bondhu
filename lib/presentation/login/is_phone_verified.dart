import 'package:complete_advanced_flutter/presentation/main/main_view.dart';
import 'package:complete_advanced_flutter/presentation/register/email_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IsEmailVerified extends StatefulWidget {
  const IsEmailVerified({Key? key}) : super(key: key);

  @override
  State<IsEmailVerified> createState() => _IsEmailVerifiedState();
}

class _IsEmailVerifiedState extends State<IsEmailVerified> {
  User? _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _user?.reload();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = snapshot.data;
              if (user != null && user.emailVerified) {
                return MainView();
              }else{
                return EmailVerify();
              }
            }
            return Center(child: CircularProgressIndicator());
          });
    }
  }
}

