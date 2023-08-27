import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackTruckScreen extends StatelessWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(12.93626232871436, 77.60621561694676),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {
    const Marker(
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
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: _markers,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: TrackTruckScreen()));
}
