import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wheelie/helpers/theme_colors.dart';

//Admin
import 'package:wheelie/screens/dashboards/admin/admin_home.dart';
import 'package:wheelie/screens/dashboards/admin/profile.dart';
import 'package:wheelie/screens/dashboards/admin/registered_driver.dart';
import 'package:wheelie/screens/dashboards/admin/registered_parent.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    RegisteredDriverScreen(),
    RegisteredParentScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: ThemeColors
            .YellowColor, // Set the app bar background color to yellow
        foregroundColor: Colors.black, // Set the app bar text color to black
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Color.fromARGB(255, 0, 0,
            0), // Set the bottom navigation bar background color to white
        selectedItemColor:
            Colors.black, // Set the selected item text color to yellow
        unselectedItemColor: ThemeColors
            .YellowColor, // Set the unselected item text color to black
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_outlined),
            label: 'Registered Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_outlined),
            label: 'Registered Parents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
