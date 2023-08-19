import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:rokto_bondhu/ui/screens/home_screen.dart';
import 'package:rokto_bondhu/ui/screens/settings_screen.dart';
import 'package:rokto_bondhu/ui/utils/color_manager.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  List<Widget> pages = [
    const HomeScreen(),
    const SettingsScreen(),
  ];
  List<String> titles = [
    "Home",
    "Profile",
  ];
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          titles[_currentIndex],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),

      body: pages[_currentIndex],
      bottomNavigationBar: FlashyTabBar(
        height: 56,
        selectedIndex: _currentIndex,
        onItemSelected: (int index) {
          _currentIndex = index;
          if (mounted) {
            setState(() {});
          }
        },
        showElevation: true,

        items: [
          FlashyTabBarItem(icon: const Icon(Icons.home), title: const Text('Home'),activeColor: ColorManager.red,inactiveColor: Colors.blueGrey),
          FlashyTabBarItem(icon: const Icon(Icons.settings), title: const Text('Settings'),activeColor: ColorManager.red,inactiveColor: Colors.blueGrey),
        ],
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
