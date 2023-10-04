import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRequest {
  final String date;
  final String time;
  final String location;
  final String allotedDriver;
  final int requirement;

  BookingRequest({
    required this.date,
    required this.time,
    required this.location,
    required this.allotedDriver,
    required this.requirement,
  });

  factory BookingRequest.fromMap(Map<String, dynamic> data) {
    return BookingRequest(
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      allotedDriver: data['closestDriverName'],
      requirement: data['specialRequirements'],
    );
  }
}

class ManageBookingScreen extends StatelessWidget {
  late String currentDriverName; // Declare as late

  Future<List<BookingRequest>> fetchBookingRequests() async {
    currentDriverName = await getName(); // Assign the value here

    print(currentDriverName);
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('closestDriverName', isEqualTo: currentDriverName)
        .get();

    final requests = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return BookingRequest.fromMap(data);
    }).toList();

    return requests;
  }

  Future<String> getName() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String myName = '';

    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData =
      await _firestore.collection('driver').doc(user.uid).get();
      myName = userData['name'];
      print("My Name = " + myName);
      // print("user found");
    }

    return myName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Booking'),
      ),
      body: FutureBuilder<List<BookingRequest>>(
        future: fetchBookingRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<BookingRequest>? data = snapshot.data;
            print(data?.length);
            if (data == null || data.isEmpty) {
              return Center(child: Text('No booking requests available.'));
            } else {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final request = data[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DATE: ${request.date} \nTIME: ${request.time}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Location: ${request.location}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Weight: ${request.requirement == 0 ? '0 - 50 Kg' : (request.requirement == 1 ? '50 - 100 Kg' : 'More than 100 Kg')}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ManageBookingScreen(),
  ));
}
