import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final bloodGroupController = TextEditingController();
  final areaController = TextEditingController();
  final donorRef = FirebaseFirestore.instance.collection('donors');
  final cityController = TextEditingController();

  bool onlyArea = false;
  bool onlyBloodGroup = false;
  String bgValue = "All";
  final List<String> _items2 = [
    'All',
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
    'All': ['All'],
    'Sylhet': [
      'All',
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
      'All',
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
      if (newValue == "All") {
        onlyArea = false;
      } else {
        onlyArea = true;
      }
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

  bool a = false;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> filter;
    final specificAreaOnly = FirebaseFirestore.instance
        .collection('donors')
        .where('isAvailable', isEqualTo: 'Yes')
        .where("area", isEqualTo: areaController.text)
        .snapshots();

    final specificCityOnly = FirebaseFirestore.instance
        .collection('donors')
        .where('isAvailable', isEqualTo: 'Yes')
        .where('city', isEqualTo: cityController.text)
        .snapshots();

    final specificBloodGroup = FirebaseFirestore.instance
        .collection('donors')
        .where('isAvailable', isEqualTo: 'Yes')
        .where("bloodGroup", isEqualTo: bloodGroupController.text)
        .snapshots();

    final specificBloodGroupAndArea = donorRef
        .where('bloodGroup', isEqualTo: bloodGroupController.text)
        .where('isAvailable', isEqualTo: 'Yes')
        .where('area', isEqualTo: areaController.text)
        .snapshots();

    final all = FirebaseFirestore.instance
        .collection('donors')
        .where('isAvailable', isEqualTo: 'Yes')
        .where('bloodGroup', isGreaterThan: "")
        .snapshots();

    final specificCityAndBloodGroup = donorRef
        .where('bloodGroup', isEqualTo: bloodGroupController.text)
        .where('isAvailable', isEqualTo: 'Yes')
        .where('city', isEqualTo: cityController.text)
        .snapshots();

    if (!onlyArea && onlyBloodGroup) {
      filter = specificBloodGroup;
    } else if (onlyArea && !onlyBloodGroup) {
      if (areaController.text == "All") {
        filter = specificCityOnly;
      } else {
        filter = specificAreaOnly;
      }
    } else if (onlyArea && onlyBloodGroup) {
      if (areaController.text == "All") {
        filter = specificCityAndBloodGroup;
      } else {
        filter = specificBloodGroupAndArea;
      }
    } else {
      filter = all;
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
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
                        });
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
                ],
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Flexible(
                    child: DropdownButtonFormField(
                      value: selectedCity,
                      onChanged: _onCityChanged,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      hint: const Text("City"),
                      items: cityToAreas.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Flexible(
                    child: DropdownButtonFormField(
                      value: selectedArea,
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == "All") {
                            onlyArea = false;
                          } else {
                            onlyArea = true;
                          }
                          selectedArea = newValue!;
                          areaController.text = selectedArea!;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      hint: const Text("Area"),
                      items:
                          areas.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          child: StreamBuilder(
            stream: filter,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return circularLoading();
              }
              List<ShowDonors> allDonors = [];
              snapshot.data!.docs.forEach((doc) {
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

  const ShowDonors({
    super.key,
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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                height: 80,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    area,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 4,),
                  Row(
                    children: [
                      const Text(
                        "Last Donated : ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0),
                      ),
                      Text(
                        lastDonated,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: "Gotham",
                            fontSize: 14.0),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorManager.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _makePhoneCall(phoneNumber);
                    },
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
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
