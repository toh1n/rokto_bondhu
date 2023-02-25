
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/donor.dart';
import '../../resources/color_manager.dart';
import '../../resources/components/my_textfield.dart';


class LastDonation extends StatefulWidget {
  const LastDonation({Key? key}) : super(key: key);

  @override
  State<LastDonation> createState() => _LastDonationState();
}

class _LastDonationState extends State<LastDonation> {

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


  int year = 0;




  pickLastDonatedDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year-60),
      lastDate: DateTime.now(),
    );

    if(date !=null){
      setState(() {
        year = date.year.toInt();
        lastDonated.text = date.year.toString() +"-"+ date.month.toString() +"-"+date.day.toString();
      });
    }
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    // final lastDonationDate = DateTime.parse("02-02-2022");


    final _currentUser =  FirebaseFirestore.instance.collection('donors').doc(_auth.uid).snapshots();
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
              displayNameController.text = user.displayName.toString();
              cityController.text = user.city.toString();
              areaController.text = user.area.toString();
              bloodGroupController.text = user.bloodGroup.toString();
              genderController.text = user.gender.toString();
              birthDate.text = user.dateOfBirth.toString();
              phoneNumberController.text = user.phoneNumber.toString();
              lastDonated.text = user.lastDonated.toString();

              return Center(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      children: [
                        Flexible(
                          child: TextFormField(
                            keyboardType: TextInputType.none,
                            enableInteractiveSelection: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Tell us your Happiest Day!!';
                              }
                              // else if(DateTime.now().difference(lastDonationDate).inDays < 120)
                              // {
                              //   return 'New Donation date has to be 4 month apart';
                              // }
                              // else if(DateTime.now().difference(DateTime.parse(lastDonated.text)).isNegative){
                              //   return 'New Donation date can not be higher than today';
                              //
                              //
                              // }
                              return null;
                            },
                            onTap: (){
                              pickLastDonatedDate();
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
                                "Update",
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

      await firebaseFirestore
          .collection("donors")
          .doc(user.uid)
          .set(donorModel.toMap());
      Fluttertoast.showToast(msg: "Profile Updated Successfully");

    }


  }
}

