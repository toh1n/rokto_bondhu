import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rokto_bondhu/presentation/main/settings/update_donation_date.dart';
import 'package:rokto_bondhu/presentation/main/settings/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseFirestore.instance.collection('donors').where('email',isEqualTo: user.email).snapshots();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              StreamBuilder(
                stream: _currentUser,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return circularLoading();
                  }
                  List<ShowCurrentDonor> allDonors = [];
                  snapshot.data.docs.forEach((doc) {
                    allDonors.add(ShowCurrentDonor.fromDocument(doc));
                  });
                  return Container(
                    child: Column(
                      children: allDonors,
                    ),
                  );
                },
              ),

            ],
          ),

          Column(
            children: [
              Padding(padding: EdgeInsets.all(10)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateProfile()));
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: ColorManager.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      "Update Profile Info",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              GestureDetector(
                onTap: () {
                  signUserOut();
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: ColorManager.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
            ],
          ),
        ],
      ),
    );
  }
}


class ShowCurrentDonor extends StatelessWidget {
  final String displayName;
  final String bloodGroup;
  final String area;
  final String phoneNumber;
  final String email;
  final String gender;
  final String city;
  final String dateOfBirth;
  final String lastDonated;


  ShowCurrentDonor({
    required this.displayName,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.area,
    required this.email,
    required this.gender,
    required this.city,
    required this.dateOfBirth,
    required this.lastDonated,



  });

  factory ShowCurrentDonor.fromDocument(DocumentSnapshot doc) {
    return ShowCurrentDonor(
      displayName: doc['displayName'],
      bloodGroup: doc['bloodGroup'],
      phoneNumber: doc['phoneNumber'],
      area: doc['area'],
      email: doc['email'],
      gender: doc['gender'],
      city: doc['city'],
      dateOfBirth: doc['dateOfBirth'],
      lastDonated: doc['lastDonated'],

    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Container(
                  height: 120.0,
                  width: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 185, 58, 58),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(bloodGroup,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(5)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name : $displayName"),
            Text("Gender : $gender"),
            Text("Birth Date : $dateOfBirth"),
            Text("Phone : $phoneNumber"),
            Text("Email : $email"),
            Text("Area : $area"),
            Text("City : $city"),
            Text("Last Donated : $lastDonated")
          ],
        )
      ],
    );
  }
}
