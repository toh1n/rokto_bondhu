import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rokto_bondhu/presentation/login/login.dart';
import 'package:rokto_bondhu/presentation/register/email_verify.dart';
import 'package:rokto_bondhu/presentation/resources/strings_manager.dart';
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
  final dobController = TextEditingController();
  final lastDonated = TextEditingController();

  int year = 0;
  List<String> _items2 =  ['A+','A-','B+','B-','O+','O-','AB+','AB-'];
  List<String> _items1 = [''];


  pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year-60),
      lastDate: DateTime.now(),
    );

    if(date !=null){
      setState(() {
        year = date.year.toInt();
        dobController.text = date.year.toString() +"-"+ date.month.toString() +"-"+date.day.toString();
      });
    }

  }
  pickLastDonatedDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year-60),
      lastDate: DateTime.now(),
    );

    if(date !=null){
      setState(() {
        lastDonated.text = date.year.toString() +"-"+ date.month.toString() +"-"+date.day.toString();
      });
    }
    Navigator.pop(context);

  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Have You donated Blood before?'),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    pickLastDonatedDate();

                  },
                  child: const Text('Yes')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    lastDonated.text = 'No';
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'No',
                  )),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {

    if(cityController.text == 'Sylhet'){

      _items1 = ['Ambarkhana','Bondor','Sahi Eidgah','Tilagor','South Surma','Kamal Bazar'];
    }
    else{
      _items1 = [''];
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
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
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("Name can not be empty");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Please Enter a valid name.");
                    }
                  },
                  controller: displayNameController,
                  obscureText: false,
                  hintText: 'Name',
                  keyboardType: TextInputType.name,
                  onSaved: (value) {
                    displayNameController.text = value!;
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
                          validator: (value) =>
                              value == null ? 'Select Blood Group' : null,
                          onChanged: (String? val) {
                            bloodGroupController.text = val!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          hint: Text("Blood Group"),
                          items: _items2.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        child: DropdownButtonFormField(
                          validator: (value) =>
                              value == null ? 'Select Gender' : null,
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
                          validator: (value) =>
                              value == null ? 'Select City' : null,
                          onChanged: (String? val) {
                            setState(() {

                            });
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
                          validator: (value) =>
                              value == null ? 'Select area' : null,
                          onChanged: (String? val) {
                            areaController.text = val!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          hint: Text("Area"),
                          items: _items1.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                //Date of birth
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.none,
                          enableInteractiveSelection: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Tell us your Happiest Day!!';
                            }
                            else if(DateTime.now().year - year < 18)
                              {
                                return 'You have to be 18 or older to register.';
                              }
                            return null;
                          },
                          onTap: (){
                            pickDate();
                          },
                          decoration: InputDecoration(
                              hintText: "Date of Birth",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              fillColor: Colors.pinkAccent
                          ),
                          controller: dobController,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.none,
                          enableInteractiveSelection: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Tell us your Happiest Day!!';
                            }
                            return null;
                          },
                          onTap: (){
                            showAlertDialog();
                          },
                          decoration: InputDecoration(
                              hintText: "Last Donated",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              fillColor: Colors.pinkAccent
                          ),
                          controller: lastDonated,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Your Email");
                    }
                    //regex expression for email validation
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      Fluttertoast.showToast(
                          msg: "Please Enter a Valid Email.");
                      //return ("Please Enter a Valid Email.");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailController.text = value!;
                  },
                ),
                const SizedBox(height: 10),
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return ("Enter Password");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Minimum 6 characters)");
                    }
                  },
                  onSaved: (value) {
                    passwordController.text = value!;
                  },
                ),
                const SizedBox(height: 10),
                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  validator: (value) {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmPasswordController.text = value!;
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
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red)),
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
                // already have an account?
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
                        Navigator.pop(context);
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


  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFireStore()
                // ignore: body_might_complete_normally_catch_error
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFireStore() async {
    // call FireStore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    // call donor model
    DonorModel donorModel = DonorModel();

    //send value
    donorModel.email = user!.email;
    donorModel.uid = user.uid;
    donorModel.displayName = displayNameController.text;
    donorModel.city = cityController.text;
    donorModel.area = areaController.text;
    donorModel.bloodGroup = bloodGroupController.text;
    donorModel.phoneNumber = phoneNumberController.text;
    donorModel.gender = genderController.text;
    donorModel.dateOfBirth = dobController.text;
    donorModel.lastDonated  = lastDonated.text;



    await firebaseFirestore
        .collection("donors")
        .doc(user.uid)
        .set(donorModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully.");

    await _auth.currentUser?.sendEmailVerification();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EmailVerify()),
        (route) => false);
  }
}
