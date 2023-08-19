import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/screens/update_profile_screen.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';
import 'package:rokto_bondhu/ui/widgets/my_button.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: ColorManager.red,
        title: Text(
          "Settings",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(10)),
          MyButton(visible: false, voidCallback: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateProfile()));
          }, text: "Update availability"),
          Padding(padding: EdgeInsets.all(5)),
          MyButton(visible: false, voidCallback: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateProfile()));
          }, text: "Update Profile"),
          Padding(padding: EdgeInsets.all(5)),
          MyButton(visible: false, voidCallback: signUserOut, text: "Log Out"),

        ],
      ),
    );
  }
}
