import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorListScreen extends StatefulWidget {
  const DonorListScreen({Key? key}) : super(key: key);
  @override
  State<DonorListScreen> createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final bloodGroupController = TextEditingController();
  final areaController = TextEditingController();
  final donorRef = FirebaseFirestore.instance.collection('donors');

  bool onlyArea = false;
  bool onlyBloodGroup = false;
  String bgValue = "All";
  final List<String> _items1 =  ['All','Ambarkhana','Bondor','Sahi Eidgah','Tilagor','South Surma','Kamal Bazar'];
  final List<String> _items2 =  ['All','A+','A-','B+','B-','O+','O-','AB+','AB-'];



  bool a = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedValue();
  }
  Future<void> _loadSelectedValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bgValue = prefs.getString('bgValue') ?? "All";
      // onlyArea = prefs.getBool('onlyArea') ?? false;
      // onlyBloodGroup = prefs.getBool('onlyBloodGroup') ?? false;

    });
  }
  Future<void> _saveSelectedValue(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bgValue', value);
  }
  Future<void> _saveOnlyAreaValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onlyArea', value);
  }
  Future<void> _saveOnlyBloodGroupValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onlyBloodGroup', value);
  }

  @override
  void dispose() {
    _saveSelectedValue(bgValue);
    _saveOnlyBloodGroupValue(onlyBloodGroup);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> filter;
    final specificAreaOnly = FirebaseFirestore.instance
        .collection('donors')
        .where("area", isEqualTo: areaController.text)
        .snapshots();
    final specificBloodGroup = FirebaseFirestore.instance
        .collection('donors')
        .where("bloodGroup", isEqualTo: bloodGroupController.text)
        .snapshots();
    final specificBloodGroupAndArea = donorRef
        .where('bloodGroup', isEqualTo: bloodGroupController.text)
        .where('area', isEqualTo: areaController.text)
        .snapshots();
    final all = FirebaseFirestore.instance
        .collection('donors')
        .where("bloodGroup", isGreaterThan: "")
        .snapshots();

    if (!onlyArea && onlyBloodGroup) {
      filter = specificBloodGroup;
    } else if (onlyArea && !onlyBloodGroup) {
      filter = specificAreaOnly;
    } else if (onlyArea && onlyBloodGroup) {
      filter = specificBloodGroupAndArea;
    } else {
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
                      bgValue = val!;
                      if (val == "All") {
                        onlyBloodGroup = false;
                      } else {
                        onlyBloodGroup = true;
                      }
                      bloodGroupController.text = val;
                      bgValue = val;
                    });
                    _saveSelectedValue(val!);
                    _saveOnlyBloodGroupValue(onlyBloodGroup);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onTap: () {
                    setState(() {});
                  },
                  hint: const Text("Blood Group : All"),
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
                  validator: (value) => value == null ? 'Select area' : null,
                  onChanged: (String? val) {
                    setState(() {
                      if (val == "All") {
                        onlyArea = false;
                      } else {
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
                  hint: const Text("Area : All"),
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
              return Column(
                children: allDonors,
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
  final String lastDonated;


  const ShowDonors({super.key,
    required this.displayName,
    required this.bloodGroup,
    required this.area,
    required this.phoneNumber,
    required this.lastDonated,
  });

  factory ShowDonors.fromDocument(DocumentSnapshot doc) {
    return ShowDonors(
      displayName: doc['displayName'],
      bloodGroup: doc['bloodGroup'],
      phoneNumber: doc['phoneNumber'],
      area: doc['area'],
      lastDonated: doc['lastDonated'],

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
          color: Colors.grey[100],
        ),
        padding: const EdgeInsets.only(bottom: 10.0),
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
                      SizedBox(
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
                                    color: const Color.fromARGB(255, 185, 58, 58),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(bloodGroup,
                                      style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          displayName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: "Gotham",
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_city,
                                  color: Colors.redAccent,
                                ),
                                Text(
                                  area,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Gotham",
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [

                                const Text(
                                  "Last Donated : ",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Gotham",
                                      fontSize: 14.0),
                                ),
                                Text(lastDonated,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "Gotham",
                                      fontSize: 14.0),
                                )
                              ],
                            ),
                            const SizedBox(
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
                    child: const Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 185, 58, 58),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  InkWell(
                    onTap: () {
                      _sendSMS(phoneNumber);
                    },
                    child: const Icon(
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
    );
  }
}

Container circularLoading() {
  return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10.0),
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
      ));
}
