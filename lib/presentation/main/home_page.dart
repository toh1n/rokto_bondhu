import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final bloodGroupController = TextEditingController();
  final areaController = TextEditingController();
  final donorRef = FirebaseFirestore.instance.collection('donors');

  bool onlyArea = false;
  bool onlyBloodGroup = false;


  @override
  Widget build(BuildContext context) {
    final filter;
    final specificAreaOnly = FirebaseFirestore.instance.collection('donors').where("area", isEqualTo: areaController.text).snapshots();
    final specificBloodGroup = FirebaseFirestore.instance.collection('donors').where("bloodGroup", isEqualTo: bloodGroupController.text).snapshots();
    final specificBloodGroupAndArea = donorRef.where('bloodGroup', isEqualTo: bloodGroupController.text).where('area', isEqualTo: areaController.text).snapshots();
    final all = FirebaseFirestore.instance.collection('donors').where("bloodGroup", isGreaterThan: "").snapshots();

    if(!onlyArea && onlyBloodGroup)
      {
         filter = specificBloodGroup;
      }
    else if(onlyArea && !onlyBloodGroup)
      {
        filter = specificAreaOnly;
      }
    else if(onlyArea && onlyBloodGroup)
      {
        filter = specificBloodGroupAndArea;
      }
    else
      {
        filter = all;
      }


    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: DropdownButtonFormField(
                  validator: (value) =>
                      value == null ? 'Select Blood Group' : null,
                  onChanged: (String? val) {
                    setState(() {
                      if(val == "All")
                        {
                          onlyBloodGroup = false;
                        }
                      else{
                        onlyBloodGroup = true;
                      }
                      bloodGroupController.text = val!;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  onTap: () {
                    setState(() {});
                  },
                  hint: Text("Blood Group : All"),
                  items: [
                    DropdownMenuItem(
                      child: Text("All"),
                      value: "All",
                    ),
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
                  validator: (value) => value == null ? 'Select area' : null,
                  onChanged: (String? val) {
                    setState(() {
                      if(val == "All")
                      {
                        onlyArea = false;
                      }
                      else{
                        onlyArea = true;
                      }
                      areaController.text = val!;
                    });
                  },
                  onTap: () {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  hint: Text("Area : All"),
                  items: [
                    DropdownMenuItem(
                      child: Text("All"),
                      value: "All",
                    ),
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
        SizedBox(
          child: StreamBuilder(

            stream: filter,

            // stream: filter ? donorRef.where("bloodGroup", isGreaterThan: "").snapshots()
            //     : donorRef.where('bloodGroup', isEqualTo: bloodGroupController.text)
            //     .where('area', isEqualTo: areaController.text)
            //     .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return circularLoading();
              }
              List<ShowDonors> allDonors = [];
              snapshot.data.docs.forEach((doc) {
                allDonors.add(ShowDonors.fromDocument(doc));
              });
              return Container(
                child: Column(
                  children: allDonors,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class ShowDonors extends StatelessWidget {
  final String displayName;
  final String bloodGroup;
  final String area;
  final String phoneNumber;

  ShowDonors({
    required this.displayName,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.area,
  });

  factory ShowDonors.fromDocument(DocumentSnapshot doc) {
    return ShowDonors(
      displayName: doc['displayName'],
      bloodGroup: doc['bloodGroup'],
      phoneNumber: doc['phoneNumber'],
      area: doc['area'],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          color: Colors.grey[200],
        ),
        padding: EdgeInsets.only(bottom: 10.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
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
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            displayName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontFamily: "Gotham",
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.redAccent,
                                  ),
                                  Text(
                                    "$area",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Gotham",
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _makePhoneCall(phoneNumber);
                      },
                      child: Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 185, 58, 58),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    InkWell(
                      onTap: () {
                        _sendSMS(phoneNumber);
                      },
                      child: Icon(
                        Icons.sms,
                        color: Color.fromARGB(255, 185, 58, 58),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

Container circularLoading() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
      ));
}
