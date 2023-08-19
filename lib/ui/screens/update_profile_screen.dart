import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rokto_bondhu/data/models/donor_model.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';
import 'package:rokto_bondhu/ui/widgets/my_text_field.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  final _auth = FirebaseAuth.instance.currentUser!;


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
  final birthDate = TextEditingController();
  final lastDonated = TextEditingController();
  final isAvailable = TextEditingController();

  int year = 0;

  List<String> _items2 =  ['A+','A-','B+','B-','O+','O-','AB+','AB-'];
  List<String> _items1 = [''];

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
      'Bisawanth',],
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
      'Elenga',],
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

  @override
  void dispose() {
    cityController.dispose();
    areaController.dispose();
    super.dispose();
  }






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
  }
  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure to delete your account?'),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    try {
                      _auth.delete();

                    } catch (e) {
                      print('Error deleting user: $e');
                    }
                    Navigator.pop(context);

                  },
                  child: const Text('Yes')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
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

    final uid = _auth.uid;

    final _currentUser =  FirebaseFirestore.instance.collection('donors').doc(uid).snapshots();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Color.fromARGB(255, 185, 58, 58),
        title: Text(
          "Update Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _currentUser,
          builder: (context,AsyncSnapshot snapshot){
            if (snapshot.hasData && snapshot.data != null) {
              DonorModel user = DonorModel.fromMap(snapshot.data!.data());
              // displayNameController.text = user.displayName.toString();
              // cityController.text = user.city.toString();
              // areaController.text = user.area.toString();
              // bloodGroupController.text = user.bloodGroup.toString();
              // genderController.text = user.gender.toString();
              // birthDate.text = user.dateOfBirth.toString();
              // phoneNumberController.text = user.phoneNumber.toString();
              // lastDonated.text = user.lastDonated.toString();
              isAvailable.text = user.isAvailable.toString();

              return Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),

                      //displayName
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
                      MyTextField(
                        controller: phoneNumberController,
                        hintText: 'Phone Number',
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value){

                          RegExp regex = new RegExp(r"^(?:\+88|88)?(01[3-9]\d{8})$");
                          if(value!.isEmpty)
                          {
                            return ("Please enter your phone number.");
                          }
                          if(!regex.hasMatch(value))
                          {
                            return ("Please enter a valid phone number.");
                          }
                        },
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
                                value: selectedCity,
                                validator: (value) =>
                                value == null ? 'Select City' : null,
                                onChanged: _onCityChanged,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                hint: Text("City"),
                                items: cityToAreas.keys
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
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
                                hint: Text("Area"),
                                items:  areas.map<DropdownMenuItem<String>>((String value) {
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
                                    hintText: "Birth Date",
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
                                  pickLastDonatedDate();
                                },
                                decoration: InputDecoration(
                                    hintText: "Last Donation date",
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
                      const SizedBox(height: 20),
                      // Register button
                      GestureDetector(
                        onTap: () {
                          postDetailsToFireStore();
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
                              "Update Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            };
          },
        ),
      ),
    );
  }

  postDetailsToFireStore() async {

    if (_formKey.currentState!.validate()) {

      // call FireStore
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth;

      // call donor model
      DonorModel donorModel = DonorModel();

      //send value
      donorModel.email = user.email;
      donorModel.uid = user.uid;
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
          .doc(user.uid)
          .set(donorModel.toMap());
      Fluttertoast.showToast(msg: "Profile Updated Successfully");

    }


  }
}

