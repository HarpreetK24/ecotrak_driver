import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyBookingPageWidget extends StatefulWidget {
  const MyBookingPageWidget({Key? key}) : super(key: key);

  @override
  _MyBookingPageWidgetState createState() => _MyBookingPageWidgetState();
}

class _MyBookingPageWidgetState extends State<MyBookingPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadUserBookings();
  }

  List<Booking> userBookings = [];

  Future<void> loadUserBookings() async {
    String myName = '';
    User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData =
      await _firestore.collection('driver').doc(user.uid).get();
      myName = userData['name'];
      print("My Name = " + myName);

      QuerySnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .where('closestDriverName', isEqualTo: myName)
          .get();

      print("Number of bookings: ${bookingSnapshot.docs.length}");
      print("Booking data: ${bookingSnapshot.docs}");

      setState(() {
        userBookings = bookingSnapshot.docs
            .map((doc) => Booking.fromSnapshot(doc))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFE1F5FE),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'My Bookings',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userBookings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                        child: GestureDetector(
                          onTap: () {
                            if (userBookings[index].status == 'Driver allocated') {
                              showOTPDConfirmationDialog(userBookings[index]);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF009688),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pickup Location:',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Expanded(
                                        child: Text(
                                          userBookings[index].pickupLocation,
                                          style: TextStyle(
                                            fontFamily: 'Readex Pro',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Booking Date:',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 48),
                                      Expanded(
                                        child: Text(
                                          userBookings[index].bookingDate,
                                          style: TextStyle(
                                            fontFamily: 'Readex Pro',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Booking Time:',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 47),
                                      Expanded(
                                        child: Text(
                                          userBookings[index].bookingTime,
                                          style: TextStyle(
                                            fontFamily: 'Readex Pro',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status:',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 97),
                                      Expanded(
                                        child: Text(
                                          userBookings[index].status == 'Driver allocated'
                                              ? 'Pickup Pending'
                                              : 'Picked Up',
                                          style: TextStyle(
                                            fontFamily: 'Readex Pro',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Estimated Weight:',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Text(
                                          userBookings[index].weight,
                                          style: TextStyle(
                                            fontFamily: 'Readex Pro',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showOTPDConfirmationDialog(Booking booking) {
    String enteredOTP = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Pick Up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please enter the OTP send to the Customer to Confirm Pick Up:'),
              TextField(
                onChanged: (value) {
                  enteredOTP = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (enteredOTP == booking.generatedOtp.toString()) {
                  updateBookingStatus(booking, 'Picked Up');
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect OTP. Please try again.'),
                    ),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void updateBookingStatus(Booking booking, String newStatus) {
    _firestore
        .collection('bookings')
        .doc(booking.bookingId)
        .update({'status': newStatus})
        .then((_) {
      setState(() {
        booking.status = newStatus;
      });
    });
  }
}

class Booking {
  final String bookingId; // Add a field for the booking ID
  final String pickupLocation;
  final String bookingDate;
  final String bookingTime;
  String status;
  final String weight;
  final int generatedOtp;

  Booking({
    required this.bookingId,
    required this.pickupLocation,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
    required this.weight,
    required this.generatedOtp,
  });

  factory Booking.fromSnapshot(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Booking(
      bookingId: doc.id,
      pickupLocation: data['location'] ?? '',
      bookingDate: _formatDate(data['date'] ?? ''),
      bookingTime: data['time'] ?? '',
      status: data['status'] ?? '',
      weight: data['specialRequirements'] ?? '',
      generatedOtp: data['otp'],
    );
  }

  static String _formatDate(String dateTime) {
    final DateTime parsedDateTime = DateTime.parse(dateTime);
    final String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDateTime);
    return formattedDate;
  }
}
