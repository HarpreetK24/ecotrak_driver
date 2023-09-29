import 'dart:async';
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

      _markers.add(
          Marker(
            markerId: MarkerId('marker_2'),
            position: truckLatLang,
            // icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow: InfoWindow(
              title: 'Drivers Location',
            ),
          )
      );

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

      //Code to travel to a location when the user clicks on a button.
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_activity),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () async {

          // getUserCurrentLocation().then((value) async{
          //   print("My Current Location ");
          //   print(value.latitude.toString() + " " + value.longitude.toString());
          //   CameraPosition cameraPosition = CameraPosition(
          //       zoom: 18,
          //       target: LatLng(value.latitude, value.longitude));
          //
          //   final GoogleMapController controller = await _controller.future;
          //
          //   controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          //   setState(() {
          //
          //   });
          //   await getDirections();
          // });
          await getDirections();
        },
      ),


    );
  }

  // Method to fetch directions from Google Maps Directions API
  Future<void> getDirections() async {
    final apiKey = 'AIzaSyCeQw-v5hINjIaUr6i-MdrfCZTfeP_TsgU'; // Replace with your Google Maps API key
    final origin = "${_markers[0].position.latitude},${_markers[0].position.longitude}";
    final destination = "${_markers[1].position.latitude},${_markers[1].position.longitude}";
    final url = "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK") {
        final List<dynamic> routes = data["routes"];
        if (routes.isNotEmpty) {
          final List<dynamic> legs = routes[0]["legs"];
          final List<LatLng> points = <LatLng>[];
          for (final dynamic step in legs[0]["steps"]) {
            final startLocation = step["start_location"];
            points.add(LatLng(startLocation["lat"], startLocation["lng"]));
            final polyline = step["polyline"]["points"];
            final List<LatLng> decodedPolyline = decodePolyline(polyline);
            points.addAll(decodedPolyline);
          }

          setState(() {
            _polyline = {
              Polyline(
                polylineId: PolylineId("route"),
                color: Colors.blue,
                points: points,
                width: 5,
              ),
            };
          });
        }
      }
      else {
        print("Directions API status is not OK: ${data["status"]}");
      }
    } else {
      throw Exception("Failed to load directions Status code: ${response.statusCode}");
    }
  }

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

}
