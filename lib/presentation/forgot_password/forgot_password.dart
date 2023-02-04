import 'package:flutter/material.dart';

import '../login/components/my_textfield.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // logo
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                  ),
                  child: Image.asset(
                    ImageAssets.splashLogo,
                    height: 100,
                  ),
                ),

                const SizedBox(height: 25),

                // let's create an account for you
                Text(
                  'Enter your Email.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                // const SizedBox(height: 10),
                //
                // // password textfield
                // MyTextField(
                //   controller: passwordController,
                //   hintText: AppStrings.password,
                //   obscureText: true,
                // ),
                //
                // const SizedBox(height: 10),
                //
                // // confirm password textfield
                // MyTextField(
                //   controller: confirmPasswordController,
                //   hintText: 'Confirm Password',
                //   obscureText: true,
                // ),

                const SizedBox(height: 25),

                // sign in button
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, Routes.mainRoute);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: ColorManager.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        AppStrings.enter,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 50),

                // not a member? register now
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Already have an account?',
                //       style: TextStyle(color: Colors.grey[700]),
                //     ),
                //     const SizedBox(width: 4),
                //     GestureDetector(
                //       // onTap: widget.onTap,
                //       child: const Text(
                //         'Login now',
                //         style: TextStyle(
                //           color: Colors.blue,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
