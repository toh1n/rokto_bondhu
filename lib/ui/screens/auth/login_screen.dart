import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';
import 'package:rokto_bondhu/ui/utils/string_manager.dart';
import 'package:rokto_bondhu/ui/screens/auth/forgot_password_screen.dart';
import 'package:rokto_bondhu/ui/screens/auth/sign_up_screen.dart';
import 'package:rokto_bondhu/ui/utils/validation_manager.dart';
import 'package:rokto_bondhu/ui/widgets/big_logo.dart';
import 'package:rokto_bondhu/ui/widgets/my_button.dart';
import 'package:rokto_bondhu/ui/widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool signInProgress = false;

  void signUserIn() async {
    if (_formKey.currentState!.validate()) {
      signInProgress = true;
      setState(() {});
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        signInProgress = false;
        setState(() {});
      } on FirebaseAuthException {
        signInProgress = false;
        wrongInfoMessage();
        setState(() {});
      }
    }
  }

  void wrongInfoMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email or Password',
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
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BigLogo(),
                const SizedBox(height: 15),
                Text(
                  AppStrings.welcome,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: emailController,
                  hintText: AppStrings.email,
                  obscureText: false,
                  validator: (value) => Validator.validateEmail(value),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: AppStrings.password,
                  validator: (value) => Validator.validatePassword(value),
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen()));
                        },
                        child: const Text(
                          AppStrings.forgetPassword,
                          style: TextStyle(color: ColorManager.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                MyButton(
                    text: AppStrings.login,
                    visible: signInProgress,
                    voidCallback: signUserIn),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.notMember,
                      style: TextStyle(color: ColorManager.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero
                      ),
                      child: const Text(
                        AppStrings.signUp,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
