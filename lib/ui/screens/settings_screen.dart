import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/screens/home_screen.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';
import 'package:rokto_bondhu/ui/utils/string_manager.dart';
import 'package:rokto_bondhu/ui/widgets/my_button.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseFirestore.instance.collection('donors').where('email',isEqualTo: user.email).snapshots();
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                StreamBuilder(
                  stream: currentUser,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return circularLoading();
                    }
                    List<ShowCurrentDonor> allDonors = [];
                    snapshot.data.docs.forEach((doc) {
                      allDonors.add(ShowCurrentDonor.fromDocument(doc));
                    });
                    return Column(
                      children: allDonors,
                    );
                  },
                ),
              ],
            ),
            MyButton(visible: false, voidCallback: (){}, text: AppStrings.settings),
          ],
        ),
      ],
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
  final String isAvailable;



  const ShowCurrentDonor({super.key,
    required this.displayName,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.area,
    required this.email,
    required this.gender,
    required this.city,
    required this.dateOfBirth,
    required this.lastDonated,
    required this.isAvailable



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
      isAvailable: doc['isAvailable'],

    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: ColorManager.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                      child: Text(
                        bloodGroup,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                      displayName,
                      style: const TextStyle(
                        color:Colors.black,
                        fontSize: 20.0,
                      )
                  ),
                ),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(10)),
          const Text("Information",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w800,
            ),),
          const Divider(color: Colors.black,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                  children: [
                    const Text('Last Donated',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.0
                      ),),
                    const SizedBox(height: 5.0,),
                    Text(lastDonated,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),)
                  ]),
              Column(
                children: [
                  const Text('Gender',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0
                    ),),
                  const SizedBox(height: 5.0,),
                  Text(gender,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),)
                ],
              ),
              Column(
                children: [
                  const Text('Birth Date',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0
                    ),),
                  const SizedBox(height: 5.0,),
                  Text(dateOfBirth,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),)
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.blueAccent[400],
                size: 35,
              ),
              const SizedBox(width: 20.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(area,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),),
                  Text(city,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),)
                ],
              )

            ],
          ),
          const SizedBox(height: 5.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.phone,
                color: Colors.yellowAccent[400],
                size: 35,
              ),
              const SizedBox(width: 20.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(phoneNumber,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),),
                ],
              )

            ],
          ),
          const SizedBox(height: 5.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.email,
                color: Colors.pinkAccent[400],
                size: 35,
              ),
              const SizedBox(width: 20.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(email,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),),
                ],
              )

            ],
          ),
          const SizedBox(height: 5.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.event_available,
                color: Colors.lightGreen[400],
                size: 35,
              ),
              const SizedBox(width: 20.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Availability : $isAvailable",
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),),

                ],
              )

            ],
          ),
        ],
      ),
    );
  }
}
