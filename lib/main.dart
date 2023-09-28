// import 'dart:html';

// import 'package:ecotrak_driver/profile_screen.dart';
import 'package:ecotrak_driver/convert_latlng_to_address.dart';
import 'package:ecotrak_driver/screens/Welcome/welcome_screen.dart';
import 'package:ecotrak_driver/user_current_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ecotrak_driver/track_truck_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';
import 'dashboard_screen.dart';
import 'firebase_options.dart';
// import 'constants.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dashboard_screen.dart';
// import 'manage_booking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: AuthChecker(),

    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(), // Listen to authentication state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return CircularProgressIndicator(); // You can replace this with a loading widget
        } else if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, navigate to the dashboard
          return DashboardScreen(); // Replace with your actual dashboard screen
        } else {
          // User is not logged in, show the welcome screen
          return WelcomeScreen(); // Replace with your actual welcome screen
        }
      },
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     title: 'EcoTrak',
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       primarySwatch: Colors.lightGreen,
//       visualDensity: VisualDensity.adaptivePlatformDensity,
//     ),
//     home: DashboardScreen(),
//     routes: {
//       '/trackTruck': (context) => TrackTruckScreen(),
//       '/profile': (context) => ProfileScreen(),
//       '/manageBooking': (context) => ManageBookingScreen(),
//     },
//   );
// }

// home: const ConvertLatLangToAddress(),

//To Call Direction API and Page.
// home: const GetUserCurrentLocationScreen(),

  //
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: GeolocationApp(),
  //   );
  // }



// class GeolocationApp extends StatefulWidget {
//   const GeolocationApp({super.key});
//
//   @override
//   State<GeolocationApp> createState() => _GeolocationAppState();
// }
//
// class _GeolocationAppState extends State<GeolocationApp> {
//
//
//   //Logic of the App
//   Position? _currentLocation;
//   late bool servicePermission = false;
//   late LocationPermission permission;
//
//   String _currentAddress = "";
//
//   Future<Position> _getCurrentLocation() async {
//     servicePermission = await Geolocator.isLocationServiceEnabled();
//     if (!servicePermission) {
//       print("Service Disabled");
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
//   _getAddressFromCoordinates() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentLocation!.latitude, _currentLocation!.longitude);
//
//       Placemark place = placemarks[0];
//
//       setState(() {
//         _currentAddress = "${place.locality}, ${place.country}";
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Get User Location"),
//         centerTitle: true,
//       ),
//       body: Center(
//           child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               "Location Coordinates",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 6,
//             ),
//             Text(
//                 "Latitude = ${_currentLocation?.latitude} ; Longitude = ${_currentLocation?.longitude}"),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               "Location Address",
//               // "Latitude = ${_currentLocation?.latitude} ; Longitude = ${_currentLocation?.latitude}",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 6,
//             ),
//             Text("${_currentAddress}"),
//             SizedBox(
//               height: 50,
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   setState(() async {
//                     _currentLocation = await _getCurrentLocation();
//                     await _getAddressFromCoordinates();
//
//                     print("${_currentLocation}");
//                     print("${_currentAddress}");
//                   });
//                 },
//                 child: Text("Get location"))
//           ],
//       )),
//     );
//   }
// }
