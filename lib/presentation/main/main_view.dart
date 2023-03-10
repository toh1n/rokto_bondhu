import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rokto_bondhu/model/chat_model.dart';
import '../../model/massage.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'chat_page.dart';
import 'home_page.dart';
import 'settings/settings_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {


  List<Widget> pages = [
    HomePage(),
    ChatPage(),
    SettingsPage()
  ];
  List<String> titles = [
    AppStrings.home,
    AppStrings.chat,
    AppStrings.settings,
  ];
  var _title = AppStrings.home;
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Color.fromARGB(255, 185, 58, 58),
        title: Text(
          _title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: ColorManager.lightGrey, spreadRadius: AppSize.s1)
        ]),
        child: GNav(
            backgroundColor: Color.fromARGB(255, 185, 58, 58),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(255, 185, 58, 58),
            padding: EdgeInsets.all(20),
            gap: 5,
            onTabChange: onTap,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.chat,
                text: 'Chat',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ]),
      ),
    );
  }

  onTap(int index) {
    setState(() {

      _currentIndex = index;
      _title = titles[index];
    });
  }
}
