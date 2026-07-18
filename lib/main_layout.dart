import 'package:flutter/material.dart';

import 'features/home/view/screens/home_screen.dart';
import 'features/profile/profile_screen.dart';


class MainLayout extends StatefulWidget {
  static const String routeName = 'MainLayout';

  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff5F33E1),
    unselectedItemColor: Colors.grey,
    onTap: (index) {
    setState(() {
    currentIndex = index;
    });
    },
    items: const [
    BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Home',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Profile',
    ),
    ],
    ));
  }
}