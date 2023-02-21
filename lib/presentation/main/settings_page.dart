import 'package:flutter/material.dart';

import '../resources/color_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(10)),
            CircleAvatar(
              child: Icon(Icons.access_alarm_rounded),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name"),
                Text("Blood Group"),
                Text("Gender"),
                Text("Age"),
                Text("Location"),
              ],
            )
          ],
        ),
        Padding(padding: EdgeInsets.all(10)),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: ColorManager.red,
              borderRadius: BorderRadius.circular(8),
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
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: ColorManager.red,
              borderRadius: BorderRadius.circular(8),
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
      ],
    );
  }
}
