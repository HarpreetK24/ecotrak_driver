import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRequest {
  final String date;
  final String time;
  final String location;

  BookingRequest({
    required this.date,
    required this.time,
    required this.location,
  });

  factory BookingRequest.fromMap(Map<String, dynamic> data) {
    return BookingRequest(
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
    );
  }
}

class ManageBookingScreen extends StatelessWidget {
  Future<List<BookingRequest>> fetchBookingRequests() async {
    final querySnapshot =
    await FirebaseFirestore.instance.collection('bookings').get();

    final requests = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return BookingRequest.fromMap(data);
    }).toList();

    return requests;
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
                          SizedBox(height: 8),
                          Text(
                            'Location: ${request.location}',
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
