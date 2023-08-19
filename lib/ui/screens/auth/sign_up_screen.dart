import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rokto_bondhu/data/models/donor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';
import 'package:rokto_bondhu/ui/utils/string_manager.dart';
import 'package:rokto_bondhu/ui/utils/validation_manager.dart';
import 'package:rokto_bondhu/ui/widgets/big_logo.dart';
import 'package:rokto_bondhu/ui/widgets/my_button.dart';
import 'package:rokto_bondhu/ui/widgets/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
  final isAvailable = TextEditingController();

  bool signUpInProgress = false;

  int year = 0;
  final List<String> _items2 = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  String? selectedCity;
  String? selectedArea;
  List<String> areas = [];

  final Map<String, List<String>> cityToAreas = {
    'Sylhet': [
      'Sylhet City',
      'Maulvibazar',
      'Habiganj',
      'Sunamganj',
      'Sreemangal',
      'Kulaura',
      'Beanibazar',
      'Barlekha',
      'Zakiganj',
      'Chhatak',
      'Balagonj',
      'Osmaninogor',
      'Joggonathpur',
      'Bisawanth',
    ],
    'Dhaka': [
      'Dhaka City',
      'Ghorashal',
      'Monohardi',
      'Shibpur',
      'Raipura',
      'Madhabdi',
      'Mirzapur',
      'Dhanbari',
      'Madhupur',
      'Gopalpur',
      'Ghatail',
      'Kalihati',
      'Sakhipur',
      'Bhuapur',
      'Elenga',
    ],
  };

  void _onCityChanged(String? newValue) {
    setState(() {
      selectedCity = newValue;
      areas = cityToAreas[newValue!]!;
      selectedArea = areas[0];
      cityController.text = selectedCity!;
      areaController.text = selectedArea!;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedCity = cityToAreas.keys.first;
    areas = cityToAreas[selectedCity!]!;
    selectedArea = areas[0];
    cityController.text = selectedCity!;
    areaController.text = selectedArea!;
  }

  pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 60),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        year = date.year.toInt();
        dobController.text = "${date.year}-${date.month}-${date.day}";
      });
    }
  }

  pickLastDonatedDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 60),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        lastDonated.text = "${date.year}-${date.month}-${date.day}";
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
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const BigLogo(),
                    const SizedBox(height: 15),
                    const Text(
                      'Let\'s create an account for you!',
                      style: TextStyle(
                        color: ColorManager.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      validator: (value) => Validator.validateName(value),
                      controller: displayNameController,
                      obscureText: false,
                      hintText: 'Name',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: phoneNumberController,
                      hintText: 'Phone Number',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          Validator.validateBangladeshiPhoneNumber(value),
                    ),
                    const SizedBox(height: 10),
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
                              hint: const Text("Blood Group"),
                              items: _items2.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
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
                              hint: const Text("Gender"),
                              items: const [
                                DropdownMenuItem(
                                  value: "Male",
                                  child: Text("Male"),
                                ),
                                DropdownMenuItem(
                                  value: "Female",
                                  child: Text("Female"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: DropdownButtonFormField(
                              value: selectedCity,
                              validator: (value) =>
                                  value == null ? 'Select City' : null,
                              onChanged: _onCityChanged,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                              hint: const Text("City"),
                              items: cityToAreas.keys
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Flexible(
                            child: DropdownButtonFormField(
                              value: selectedArea,
                              validator: (value) =>
                                  value == null ? 'Select area' : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedArea = newValue!;
                                  areaController.text = selectedArea!;
                                });
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                              hint: const Text("Area"),
                              items: areas.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                } else if (DateTime.now().year - year < 18) {
                                  return 'You have to be 18 or older to register.';
                                }
                                return null;
                              },
                              onTap: () {
                                pickDate();
                              },
                              decoration: InputDecoration(
                                  hintText: "Date of Birth",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.pinkAccent),
                              controller: dobController,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.none,
                              enableInteractiveSelection: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Have you ever donated blood before?';
                                }
                                return null;
                              },
                              onTap: () {
                                showAlertDialog();
                              },
                              decoration: InputDecoration(
                                  hintText: "Last Donated",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.pinkAccent),
                              controller: lastDonated,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: DropdownButtonFormField(
                              validator: (value) => value == null
                                  ? "Are you available to donate?"
                                  : null,
                              onChanged: (String? val) {
                                setState(() {});
                                isAvailable.text = val!;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                              hint: const Text("Are you available to donate?"),
                              items: const [
                                DropdownMenuItem(
                                  value: "Yes",
                                  child: Text("Yes"),
                                ),
                                DropdownMenuItem(
                                  value: "NO",
                                  child: Text("No"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      validator: (value) => Validator.validateEmail(value),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                      validator: (value) => Validator.validatePassword(value),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      validator: (value) =>
                          Validator.validatePasswordConfirmation(
                              passwordController.text, value),
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      text: AppStrings.signUp,
                      visible: signUpInProgress,
                      voidCallback: () {
                        signUp(emailController.text, passwordController.text);
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Login now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      signUpInProgress = true;
      setState(() {});
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => () {
                  postDetailsToFireStore();
                });
        signUpInProgress = false;
        setState(() {});
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: "${e.message}");
        signUpInProgress = false;
        setState(() {});
      }
    }
  }

  postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    DonorModel donorModel = DonorModel();

    donorModel.email = _auth.currentUser!.email;
    donorModel.uid = _auth.currentUser!.uid;
    donorModel.displayName = displayNameController.text;
    donorModel.city = cityController.text;
    donorModel.area = areaController.text;
    donorModel.bloodGroup = bloodGroupController.text;
    donorModel.phoneNumber = phoneNumberController.text;
    donorModel.gender = genderController.text;
    donorModel.dateOfBirth = dobController.text;
    donorModel.lastDonated = lastDonated.text;
    donorModel.isAvailable = isAvailable.text;

    await firebaseFirestore
        .collection("donors")
        .doc(_auth.currentUser!.uid)
        .set(donorModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully.");

    await _auth.currentUser?.sendEmailVerification();

    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => EmailVerify1()),
    //         (route) => false);
  }
}
