import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/helpers/current_logged_person.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/helpers/utils.dart';

// Admin
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
  String adminName = ''; // Variable to store the admin's name

  final List<Widget> _screens = [
    HomeScreen(),
    RegisteredDriverScreen(),
    RegisteredParentScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/loginbg.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wheelie',
                    style: GoogleFonts.poppins(
                      color: ThemeColors.titleColor,
                      fontSize: FontSize.xxxLarge,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 15), // Add some spacing between the texts
                  StreamBuilder<String>(
                    stream: fetchCurrentUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data == 'Unknown') {
                        return const Text('User not found.');
                      }

                      var adminName = snapshot.data;

                      return Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'UserName: $adminName',
                            style: GoogleFonts.poppins(
                              color: ThemeColors.titleColor,
                              fontSize: FontSize.xMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_outlined),
              title: Text('Registered Drivers'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_outlined),
              title: Text('Registered Parents'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                logout(context);
              },
            ),
          ],
        ),
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
        items: const [
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
