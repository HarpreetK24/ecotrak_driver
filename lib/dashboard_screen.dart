import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'track_truck_screen.dart';
import 'profile_screen.dart';
import 'manage_booking_screen.dart';
import 'manage_booking_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override

  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  File? _profileImage;
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }
  List<Widget> _widgetOptions = [
    TrackTruckScreen(),
    ProfileScreen(),
    ManageBookingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ecotrak'),
      ),
      drawer: buildSidebar(context),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildSidebar(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      :Image.asset("assets/images/donate-blood-collage-coronavirus-icons-vector-30596014.png").image,
                ),
                SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harpreet', // Replace with user's name
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Driver', // Replace with user's membership status
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rewards'),
            onTap: () {
              // Navigate to rewards screen
              Navigator.pushNamed(context, '/rewards');
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Change Profile Picture'),
            onTap: () async {
              await _pickImage(ImageSource.gallery);
              Navigator.pop(context); // Close the drawer after selecting image
            },
          ),
        ],
      ),
    );
  }


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Track Truck',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.event_note),
        //   label: 'Special Booking',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Manage Booking',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
