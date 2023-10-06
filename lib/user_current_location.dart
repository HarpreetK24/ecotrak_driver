import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetUserCurrentLocationScreen extends StatefulWidget {
  const GetUserCurrentLocationScreen({super.key});

  @override
  State<GetUserCurrentLocationScreen> createState() => _GetUserCurrentLocationScreenState();
}

class _GetUserCurrentLocationScreenState extends State<GetUserCurrentLocationScreen> {

  Completer<GoogleMapController> _controller = Completer();
  Uint8List? markerImages;
  String truckImages = 'image/dump_truck_icon.png';
  LatLng truckLatLang = LatLng(12.93626232871436, 77.60621561694676);
  bool isDriverAvailable = false;
  bool isSessionActive = false;
  Position? _currentPosition; // Store the current location
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  String get currentUserId => _auth.currentUser?.uid ?? '';

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(12.93626232871436, 77.60621561694676),
    zoom: 14.4746,
  );

  Set<Polyline> _polyline ={};

  Future<Uint8List> getBytesFromAssets(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  List<LatLng> pointslatlng = [];

  final List<Marker> _markers = <Marker>[];

  //Loading the Location of the User on app start
  //Storing the user Current Longitude and Latitude and fetching it using LatLng(value.latitude, value.longitude))
  loadData ()  {
    getUserCurrentLocation().then((value) async{
      print("My Current Location ");
      print(value.latitude.toString() + " " + value.longitude.toString());

      pointslatlng = [LatLng(value.latitude, value.longitude), truckLatLang];

      // final Uint8List markerIcon = await getBytesFromAssets(truckImages, 100);
      _markers.add(
          Marker(
            markerId: MarkerId('marker_1'),
            position: LatLng(value.latitude, value.longitude),
            // icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow: InfoWindow(
              title: 'My Current Location',
            ),
          )
      );



      // _markers.add(
      //     Marker(
      //       markerId: MarkerId('marker_2'),
      //       position: truckLatLang,
      //       // icon: BitmapDescriptor.fromBytes(markerIcon),
      //       infoWindow: InfoWindow(
      //         title: 'Drivers Location',
      //       ),
      //     )
      // );

      // _polyline.add(
      //   Polyline(polylineId: PolylineId('1'),
      //       points: pointslatlng
      //   ),
      // );

      //Moving to the position
      CameraPosition cameraPosition = CameraPosition(
          zoom: 18,
          target: LatLng(value.latitude, value.longitude));

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {

      });

    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {


    }).onError((error, stackTrace) {
      print("Error: - " + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    loadData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: _kGooglePlex,
         markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          polylines: _polyline,
        ),
      ),

      // Code to travel to a location when the user clicks on a button.
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.local_activity),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () async {
              // Handle your action here
            },
          ),
          SizedBox(height: 16),
            FloatingActionButton(
              child: Icon(
                  isSessionActive ? Icons.stop : Icons.play_arrow,
              ),
              onPressed: () {
                // Call the start session method
                _toggleSession();
              },
            ),
        ],
      ),

    );
  }

  // Method to fetch directions from Google Maps Directions API
  // Future<void> getDirections() async {
  //   final apiKey = 'AIzaSyCeQw-v5hINjIaUr6i-MdrfCZTfeP_TsgU'; // Replace with your Google Maps API key
  //   final origin = "${_markers[0].position.latitude},${_markers[0].position.longitude}";
  //   final destination = "${_markers[1].position.latitude},${_markers[1].position.longitude}";
  //   final url = "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey";
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     if (data["status"] == "OK") {
  //       final List<dynamic> routes = data["routes"];
  //       if (routes.isNotEmpty) {
  //         final List<dynamic> legs = routes[0]["legs"];
  //         final List<LatLng> points = <LatLng>[];
  //         for (final dynamic step in legs[0]["steps"]) {
  //           final startLocation = step["start_location"];
  //           points.add(LatLng(startLocation["lat"], startLocation["lng"]));
  //           final polyline = step["polyline"]["points"];
  //           final List<LatLng> decodedPolyline = decodePolyline(polyline);
  //           points.addAll(decodedPolyline);
  //         }
  //
  //         setState(() {
  //           _polyline = {
  //             Polyline(
  //               polylineId: PolylineId("route"),
  //               color: Colors.blue,
  //               points: points,
  //               width: 5,
  //             ),
  //           };
  //         });
  //       }
  //     }
  //     else {
  //       print("Directions API status is not OK: ${data["status"]}");
  //     }
  //   } else {
  //     throw Exception("Failed to load directions Status code: ${response.statusCode}");
  //   }
  // }

  // Method to decode polyline points
  List<LatLng> decodePolyline(String encoded) {
    final List<LatLng> poly = <LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final double latitude = lat / 1e5;
      final double longitude = lng / 1e5;
      final LatLng position = LatLng(latitude, longitude);
      poly.add(position);
    }

    return poly;
  }


  // Function to get the current location
  void _getCurrentLocation() async {
    try {
      // Request permission to access the device's location
      final bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        // Handle the case where location services are disabled
        // You can display a message or guide the user to enable location services
        return;
      }

      final LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denied location permissions
        // You can display a message or guide the user to enable location permissions
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle the case where the user denied location permissions permanently
        // You can display a message or guide the user to app settings
        return;
      }

      // Get the current location
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentPosition = position; // Store the current location
        print(_currentPosition);
      });
      if(_currentPosition != null) {
        // Create a GeoPoint from the latitude and longitude
        GeoPoint geoPoint = GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude);

        // Get a reference to the driver's document in the "drivers" collection
        DocumentReference driverDocRef = _firestore.collection('driver').doc(currentUserId);

        // Update the location field in the driver's document
        // Update the location field in the driver's document
        await driverDocRef.update({'location': geoPoint}).then((_) {
          print("Location updated successfully");
        }).catchError((error) {
          print("Error updating location: $error");
        });
      }
      else {
        print("it is null");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _toggleSession() {
    setState(() {
      isSessionActive = !isSessionActive;
    });

    // Perform other session-related actions here
    if (isSessionActive) {
      // Start the session
      _startSession();
      _showSessionSnackbar("Session Started");

    } else {
      // Stop the session
      // Update Firestore column to indicate unavailability
      _endSession();
      _showSessionSnackbar("Session Ended");

    }
  }

  // Function to display a Snackbar
  void _showSessionSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Method to update the driver's location (similar to your existing logic)
  Future<void> updateDriverLocation() async {
    _getCurrentLocation();
  }

  // Method to start the session
  void _startSession() async {
    // Set driver availability to true
    isDriverAvailable = true;

    // Update the UI
    setState(() {});

    // Update driver availability in Firestore
    // Replace 'currentUserId' with the actual user ID
    User? user = FirebaseAuth.instance.currentUser;
    String? currentUserId = user?.uid;
    print(currentUserId);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('driver').doc(currentUserId).update({
      'isAvailable': isDriverAvailable,
    });

    // Update the driver's location (you can reuse your existing location update logic here)
    await updateDriverLocation();
  }
  void _endSession() async {
    isDriverAvailable = false;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('driver').doc(currentUserId).update({
      'isAvailable': isDriverAvailable,
    });
  }
}

