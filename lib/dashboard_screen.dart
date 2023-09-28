import 'dart:io';
import 'package:ecotrak_driver/screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'track_truck_screen.dart';
import 'profile_screen.dart';
import 'manage_booking_screen.dart';
// import 'package:image_picker/image_picker.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  File? _profileImage;

  final List<Widget> _widgetOptions = [
    // TrackTruckScreen(),
    //MapSample(),
    TrackTruckScreen(),
    ProfileScreen(),
    ManageBookingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecotrak'),
          backgroundColor: Colors.green
      ),
      drawer: buildSidebar(context),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  // Widget buildSidebar(BuildContext context) {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: <Widget>[
  //         DrawerHeader(
  //           decoration: const BoxDecoration(
  //             color: Colors.green,
  //           ),
  //           child: Row(
  //             children: [
  //               CircleAvatar(
  //                 radius: 40,
  //                 backgroundImage: _profileImage != null
  //                     ? FileImage(_profileImage!)
  //                     :Image.asset("assets/images/donate-blood-collage-coronavirus-icons-vector-30596014.png").image,
  //               ),
  //               const SizedBox(width: 16),
  //               const Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Nitish', // Replace with user's name
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                   SizedBox(height: 4),
  //                   Text(
  //                     'Employee', // Replace with user's membership status
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 14,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.star),
  //           title: const Text('Rewards'),
  //           onTap: () {
  //             // Navigate to rewards screen
  //             Navigator.pushNamed(context, '/rewards');
  //           },
  //         ),
  //         ListTile(
  //             leading: Icon(Icons.exit_to_app), // Logout icon
  //             title: Text('Logout'), // Logout text
  //             onTap: () {
  //               Navigator.of(context).pushAndRemoveUntil(
  //                 MaterialPageRoute(builder: (context) => WelcomeScreen()),
  //                     (Route<dynamic> route) => false, // Remove all previous routes
  //               );
  //             }
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                      'John Doe', // Replace with user's name
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Premium Member', // Replace with user's membership status
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
            // onTap: () async {
            //   await _pickImage(ImageSource.gallery);
            //   Navigator.pop(context); // Close the drawer after selecting image
            // },

          ),
          ListTile(
              leading: Icon(Icons.exit_to_app), // Logout icon
              title: Text('Logout'), // Logout text
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (Route<dynamic> route) => false, // Remove all previous routes
                );
              }
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
