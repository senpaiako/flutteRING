import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Import Iconsax
import 'package:newnew/pages/choose_location.dart';
import 'package:newnew/pages/home.dart';
import 'package:newnew/pages/loading.dart';
import 'package:newnew/pages/user_profile.dart'; // Assuming you have this for the profile page
import 'package:newnew/pages/self_service.dart'; // Assuming you have this for the self-service page

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new PostHttpOverrides();
  runApp(MaterialApp(
    initialRoute: '/loading', // Set initial route to '/loading'
    routes: {
      '/loading': (context) => Loading(),
      '/home': (context) =>
          MainNavigationBar(), // Navigate to the new bottom nav bar
      '/location': (context) => ChooseLocation(),
    },
  ));
}

class MainNavigationBar extends StatefulWidget {
  @override
  _MainNavigationBarState createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _currentIndex = 0; // Tracks selected tab

  // List of pages for the bottom navigation
  final List<Widget> _pages = [
    Home(), // Home Page (home.dart)
    SelfServicePage(), // Self-Service Page (self_service.dart)
    UserProfilePage(), // User Profile Page (user_profile.dart)
  ];

  // Function to handle tab taps
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped, // Update selected index on tap
        items: [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home), // Iconsax for Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user_tick), // Iconsax for Self-Service
            label: 'Self Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.setting), // Iconsax for Profile/Settings
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        type: BottomNavigationBarType.shifting, // Ensures all icons are visible
      ),
    );
  }
}
