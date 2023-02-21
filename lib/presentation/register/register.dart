import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_advanced_flutter/presentation/login/login.dart';
import 'package:complete_advanced_flutter/presentation/register/email_verify.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/donor.dart';
import '../resources/components/my_textfield.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {


  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final displayNameController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final genderController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final dateOfBirth = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
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
                    height: 20,
                  ),
                ),
                const SizedBox(height: 15),
                // let's create an account for you
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),

                // displayName
                MyTextField(
                  validator: (value){
                    RegExp regex = RegExp(r'^.{3,}$');
                    if(value!.isEmpty)
                    {
                      return ("Name can not be empty");
                    }
                    if(!regex.hasMatch(value))
                    {
                      return ("Please Enter a valid name.");
                    }
                  },
                  controller: displayNameController,
                  obscureText: false,
                  hintText: 'Name',
                  keyboardType: TextInputType.name,
                  onSaved: (value){
                    displayNameController.text=value!;
                  },
                ),

                const SizedBox(height: 10),

                // Phone Number textfield
                MyTextField(
                  controller: phoneNumberController,
                  hintText: 'Phone Number',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  // validator: (value){
                  //
                  //   RegExp regex = new RegExp(r"/^(?:(?:\+|00)88|01)?\d{11}$/");
                  //   if(value!.isEmpty)
                  //   {
                  //     return ("Please enter your phone number.");
                  //   }
                  //   if(!regex.hasMatch(value))
                  //   {
                  //     return ("Please enter a valid phone number.");
                  //   }
                  // },
                ),
                const SizedBox(height: 10),

                //Blood Group & Gender
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          validator: (value) => value == null
                              ? 'Select Blood Group'
                              : null,
                          onChanged: (String? val) {
                            bloodGroupController.text = val!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          hint: Text("Blood Group"),
                          items: [
                            DropdownMenuItem(
                              child: Text("A+"),
                              value: "A+",
                            ),
                            DropdownMenuItem(
                              child: Text("B+"),
                              value: "B+",
                            ),
                            DropdownMenuItem(
                              child: Text("O+"),
                              value: "O+",
                            ),
                            DropdownMenuItem(
                              child: Text("AB+"),
                              value: "AB+",
                            ),
                            DropdownMenuItem(
                              child: Text("A-"),
                              value: "A-",
                            ),
                            DropdownMenuItem(
                              child: Text("B-"),
                              value: "B-",
                            ),
                            DropdownMenuItem(
                              child: Text("O-"),
                              value: "O-",
                            ),
                            DropdownMenuItem(
                              child: Text("AB-"),
                              value: "AB-",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        child: DropdownButtonFormField(
                          validator: (value) => value == null
                              ? 'Select Gender'
                              : null,
                          onChanged: (String? val) {
                            genderController.text = val!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          hint: Text("Gender"),
                          items: [
                            DropdownMenuItem(
                              child: Text("Male"),
                              value: "Male",
                            ),
                            DropdownMenuItem(
                              child: Text("Female"),
                              value: "Female",
                            ),
                            DropdownMenuItem(
                              child: Text("Other"),
                              value: "Other",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                //City and Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          validator: (value) => value == null
                              ? 'Select City'
                              : null,
                          onChanged: (String? val) {
                            cityController.text = val!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          hint: Text("City"),
                          items: [
                            DropdownMenuItem(
                              child: Text("Sylhet"),
                              value: "Sylhet",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        child: DropdownButtonFormField(
                          validator: (value) => value == null
                              ? 'Select area'
                              : null,
                          onChanged: (String? val) {
                            areaController.text = val!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          hint: Text("Area"),
                          items: [
                            DropdownMenuItem(
                              child: Text("Bondor"),
                              value: "Bondor",
                            ),
                            DropdownMenuItem(
                              child: Text("South Surma"),
                              value: "South Surma",
                            ),
                            DropdownMenuItem(
                              child: Text("Other"),
                              value: "Other",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // email textfield
                MyTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  validator: (value){
                    if(value!.isEmpty){
                      return ("Please Enter Your Email");
                    }
                    //regex expression for email validation
                    if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
                    {
                      Fluttertoast.showToast(msg: "Please Enter a Valid Email.");
                      //return ("Please Enter a Valid Email.");
                    }
                    return null;
                  },
                  onSaved: (value){
                    emailController.text=value!;
                  },
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  validator: (value){
                    RegExp regex = new RegExp(r'^.{6,}$');
                    if(value!.isEmpty)
                    {
                      return ("Enter Password");
                    }
                    if(!regex.hasMatch(value))
                    {
                      return ("Enter Minimum 6 characters)");
                    }
                  },
                  onSaved: (value){
                    passwordController.text=value!;
                  },
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  validator: (value){
                    if(passwordController.text != confirmPasswordController.text)
                    {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  onSaved: (value){
                    confirmPasswordController.text=value!;
                  },
                ),

                const SizedBox(height: 10),

                // Register button
                GestureDetector(
                  onTap: () {
                    signUp(emailController.text, passwordController.text);
                    const SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
                      ),
                    );
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
                        AppStrings.registerText2,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginView()));
                      },
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async{
    if(_formKey.currentState!.validate())
    {
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {
        postDetailsToFireStore()
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
  postDetailsToFireStore() async{
    // call FireStore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    // call donor model
    DonorModel donorModel = DonorModel();

    //send value
    donorModel.email = user!.email;
    donorModel.uid = emailController.text;
    donorModel.displayName = displayNameController.text;
    donorModel.city = cityController.text;
    donorModel.area = areaController.text;
    donorModel.bloodGroup = bloodGroupController.text;
    donorModel.phoneNumber = phoneNumberController.text;
    donorModel.gender = genderController.text;
    donorModel.dateOfBirth = "01/08/2000";


    await firebaseFirestore.collection("donors").doc(user.uid).set(donorModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully.");

    await _auth.currentUser?.sendEmailVerification();


    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EmailVerify()), (route) => false);

  }
}
