import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complete_advanced_flutter/presentation/main/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/color_manager.dart';

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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                                child: Text("O+",
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
                  Text(user.email.toString()),
                  Text(user.uid.toString()),
                  Text(user.email.toString()),
                  Text(user.email.toString()),
                  Text(user.email.toString()),
                ],
              )
            ],
          ),
          Column(
            children: [
              Padding(padding: EdgeInsets.all(10)),
              GestureDetector(
                onTap: () {},
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

