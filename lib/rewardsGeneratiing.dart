import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: RewardsGenerate(),
  ));
}

class RewardsGenerate extends StatefulWidget {
  const RewardsGenerate({Key? key}) : super(key: key);

  @override
  _RewardsGenerateState createState() => _RewardsGenerateState();
}

class _RewardsGenerateState extends State<RewardsGenerate> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool showQRCode = false;
  String qrData = "";



  // Future<void> showNotification() async {
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   FlutterLocalNotificationsPlugin();
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     'channel_id',
  //     'Channel Name',
  //     'Channel Description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'QR Code Expired',
  //     'The QR code has expired.',
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  // }

  Future<void> expireUpdate() async {
    DocumentReference documentReference = firestore.collection('rewards').doc(qrData);

    // Update the status field of the document
    await documentReference.update({
      'status': 'expired',
    });

  }

  Future<void> generateRewards(String weight, String garbageType) async {
    String id = "";
    int rewards = 0;
    try {

      if (garbageType == 'Biodegradable') {
        int w = int.parse(weight);
        int c = w * 2; // 2 coins per Kg
        rewards = c.round();
      } else if (garbageType == 'Non-Biodegradable') {
        int w = int.parse(weight);
        int c = w * 3; // 3 coins per Kg
        rewards = c.round();
      }

      DocumentReference documentReference =
      await firestore.collection('rewards').add({
        'weight': weight,
        'garbageType': garbageType,
        'status': 'created',
        'coins': rewards,
      });

      print("Data Added Successfully...rewards = " + weight);
      print(rewards);

      id = documentReference.id;
      print("Document ID = " + id);
      setState(() {
        qrData = id;
        showQRCode = true;
      });

      // Set a timer to hide the QR code after 30 seconds
      Timer(Duration(seconds: 30), () {
        setState(() {
          showQRCode = false;
        });
        // showNotification(); // Show the notification when the QR code expires
        expireUpdate();
      });
    } catch (e) {
      print('Error unable to generate Rewards: $e');
    }
  }

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFE1F5FE),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 40, 16, 0),
                    child: Text(
                      'Rewards',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Outfit',
                        color: Color(0xFF009688),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 16, 0),
                    child: TextFormField(
                      controller: textController1,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Weight',
                        hintText: 'Enter the Weight of the Garbage',
                        hintStyle: TextStyle(fontSize: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Color(0xFFE1F5FE),
                      ),
                      style: TextStyle(fontSize: 16),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      enabled: !showQRCode,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 16, 0),
                    child: TextFormField(
                      controller: textController2,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Garbage Type',
                        hintText: 'Select the type of Garbage',
                        hintStyle: TextStyle(fontSize: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Color(0xFFE1F5FE),
                      ),
                      style: TextStyle(fontSize: 16),
                      enabled: !showQRCode,
                    ),
                  ),
                  if (!showQRCode)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await generateRewards(
                              textController1.text, textController2.text);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF009688),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(double.infinity, 55),
                        ),
                        child: Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (showQRCode)
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'QR Code',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Outfit',
                            color: Color(0xFF009688),
                          ),
                        ),
                        Center(
                          child: QrImageView(
                            data: qrData,
                            size: 280,
                            embeddedImageStyle:
                            const QrEmbeddedImageStyle(
                              size: Size(
                                100,
                                100,
                              ),
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
      ),
    );
  }
}
