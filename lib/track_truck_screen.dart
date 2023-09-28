// import 'dart:async';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TrackTruckScreen extends StatelessWidget {

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(12.93626232871436, 77.60621561694676),
    zoom: 14.4746,
  );


  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(12.93626232871436, 77.60621561694676),
      infoWindow: InfoWindow(
        title: 'Your Current Location',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),

      //Code to travel to a location when the user clicks on a button.
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_disabled_outlined),
        onPressed: () async{
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(12.914442476821588, 77.6168134358513),
              zoom: 12,
            )
          ));
        },
      ),


    );
  }
}

void main() {
  runApp(MaterialApp(home: TrackTruckScreen()));
}





//NOT REQUIRED FOR THE TIMING

// class TrackTruckScreen extends StatelessWidget {
//
//   Completer<GoogleMapController> _controller = Completer();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(12.93626232871436, 77.60621561694676),
//     zoom: 14.4746,
//   );
//
//   final Set<Marker> _markers = {
//     const Marker(
//       markerId: MarkerId('marker_1'),
//       position: LatLng(12.932970143527706, 77.61036443809877),
//       infoWindow: InfoWindow(
//         title: 'My Location 2',
//       ),
//     ),
//     const Marker(
//       markerId: MarkerId('marker_2'),
//       position: LatLng(12.93626232871436, 77.60621561694676),
//       infoWindow: InfoWindow(
//         title: 'My Location',
//       ),
//     ),
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: GoogleMap(
//           initialCameraPosition: _kGooglePlex,
//           markers: _markers,
//           onMapCreated: (GoogleMapController controller) {
//             _controller.complete(controller);
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.location_disabled_outlined),
//         onPressed: () async{
//           GoogleMapController controller = await _controller.future ;
//           controller.animateCamera(CameraUpdate.newCameraPosition(
//             CameraPosition(
//                 target: LatLng(12.93626232871436, 77.60621561694676),
//                 zoom: 14
//             )
//           ));
//           // setState(() {
//           //
//           // });
//         },
//       ),
//     );
//   }
// }
//
//
// void main() {
//   runApp(MaterialApp(home: TrackTruckScreen()));
// }


//Part 2
// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
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
//
//
//
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//
//   TextEditingController _searchController = TextEditingController();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static final Marker _kGooglePlexMarker = Marker(
//
//
//
//     markerId: MarkerId('_kGooglePlexMarker'),
//     infoWindow: InfoWindow(title: 'Google Plex'),
//     icon: BitmapDescriptor.defaultMarker,
//     position: LatLng(37.42796133580664, -122.085749655962),
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   static final Marker _kLakeMarker = Marker(
//     markerId: MarkerId('Lake'),
//     infoWindow: InfoWindow(title: 'Lake'),
//     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//     position: LatLng(37.43296265331129, -122.08832357078792),
//   );
//
//   static final Polyline _kPolyline = Polyline(
//     polylineId: PolylineId('_kPolyline'),
//     points: [
//       LatLng(37.43296265331129, -122.08832357078792),
//       LatLng(37.42796133580664, -122.085749655962),
//     ],
//     width: 5,
//   );
//
//   static final Polygon _kPolygon = Polygon(
//     polygonId: PolygonId('_kPolygon'),
//     points: [
//       LatLng(37.43296265331129, -122.08832357078792),
//       LatLng(37.42796133580664, -122.085749655962),
//       LatLng(37.418, -122.092),
//       LatLng(37.435, -122.092),
//     ],
//     strokeWidth: 5,
//     fillColor: Colors.transparent,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps'),
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                   child: TextFormField(
//                 controller: _searchController,
//                 textCapitalization: TextCapitalization.words,
//                 decoration: InputDecoration(hintText: "Search by City"),
//                 onChanged: (value) {
//                   print(value);
//                 },
//               )),
//               IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.search),
//               ),
//             ],
//           ),
//           Expanded(
//             child: GoogleMap(
//               mapType: MapType.normal,
//               markers: {
//                 _kGooglePlexMarker,
//                 // _kLakeMarker
//               },
//
//               // polylines: {
//               //   _kPolyline,
//               // },
//               //
//               // polygons: {
//               //   _kPolygon,
//               // },
//
//               initialCameraPosition: _kGooglePlex,
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//             ),
//           ),
//         ],
//       ),
//
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: _goToTheLake,
//       //   label: const Text('To the lake!'),
//       //   icon: const Icon(Icons.directions_boat),
//       // ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
