import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';
import 'package:rokto_bondhu/ui/utils/string_manager.dart';
import 'package:rokto_bondhu/ui/utils/validation_manager.dart';
import 'package:rokto_bondhu/ui/widgets/big_logo.dart';
import 'package:rokto_bondhu/ui/widgets/my_button.dart';
import 'package:rokto_bondhu/ui/widgets/my_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  bool inProgress = false;

  Future<void> resetPassword({required String email}) async {
    if(_formKey.currentState!.validate()){
      inProgress = true;
      setState(() {});
      try{
        await auth.sendPasswordResetEmail(email: email);
        inProgress = false;
        setState(() {});
        checkYourEmail();

      }catch(e){
        inProgress = false;
        setState(() {});
        Fluttertoast.showToast(msg: e.toString());
      }
    }

  }

  void checkYourEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'We have sent a link to your email.Follow the link to recover your password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  const BigLogo(),

                  const SizedBox(height: 25),
                  // Enter Your Email
                  const Text(
                    'Enter your Email.',
                    style: TextStyle(
                      color: ColorManager.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    validator: (value) => Validator.validateEmail(value),
                  ),

                  const SizedBox(height: 25),

                  MyButton(visible: inProgress, voidCallback: () {
                    resetPassword(email: _emailController.text);

                  }, text: AppStrings.recoverPassword),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
