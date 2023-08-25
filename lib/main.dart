import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'track_truck_screen.dart';
// import 'special_booking_screen.dart';
import 'profile_screen.dart';
import 'manage_booking_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecotrak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(),
      routes: {
        '/trackTruck': (context) => TrackTruckScreen(),
        '/profile': (context) => ProfileScreen(),
        '/manageBooking': (context) => ManageBookingScreen(),
      },
    );
  }
}
