import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertLatLangToAddress extends StatefulWidget {
  const ConvertLatLangToAddress({Key? key}) : super(key: key);

  @override
  State<ConvertLatLangToAddress> createState() =>
      _ConvertLatLandToAddressState();
}

class _ConvertLatLandToAddressState extends State<ConvertLatLangToAddress> {
  String stAdd = '';
  String lat = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(stAdd),
          Text(lat),
          GestureDetector(
            onTap: () async {
              try {

                // From a query
                // final query = "1600 Amphitheatre Parkway, Mountain View";
                List<Location> locations = await locationFromAddress("48-49, Kalpavriksha Student Housing, Bhuvanappa Layout, Tavarekere Main Rd, opp. Nexus Mall Parking, Tavarekere, Kaveri Layout, Adugodi, Bengaluru, Karnataka 560029");

                // final coordinates = Coordinates(12.93626232871436, 77.60621561694676);
                List<Placemark> placemarks = await placemarkFromCoordinates(12.936212774571386, 77.605970323668);

                setState(() {
                  lat = locations.last.longitude.toString() + " " + locations.last.latitude.toString();
                  // stAdd = placemarks.reversed.last.street.toString();

                  stAdd = placemarks

                      .map((placemark) =>
                  " ${placemark.street}, ${placemark.locality}, ${placemark.country}")
                      .join(", ");

                });
              } catch (e) {
                // Handle any exceptions that may occur during geocoding
                print("Error during geocoding: $e");
                setState(() {
                  stAdd = "Error during geocoding: $e";
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.green),
                child: Center(
                  child: Text('Convert'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
