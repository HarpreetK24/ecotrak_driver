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
  final _formKey = GlobalKey<FormState>();
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

    final DocumentSnapshot userData =
      await firestore.collection('rewards').doc(qrData).get();

    String currentStatus = userData['status'];

    if(currentStatus == 'created') {
      // Update the status field of the document
      await documentReference.update({
        'status': 'expired',
      });
    }

  }

  Future<void> generateRewards(String weight, String garbageType) async {
    String id = "";
    int rewards = 0;

    try {

      if (garbageType == 'Biodegradable') {
        double w = double.parse(weight);
        double c = w * 2; // 2 coins per Kg
        rewards = c.round();
      } else if (garbageType == 'Non-Biodegradable') {
        double w = double.parse(weight);
        double c = w * 5; // 3 coins per Kg
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
      Timer(Duration(seconds: 60), () {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
          Container(
          height: 80,
          child : AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF009688),
            title: true
                ? Text(
              "Generate Rewards",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            )
                : null,
            actions: <Widget>[
              if (true)
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child:Padding(
                    padding: EdgeInsets.fromLTRB(33, 3.6, 10, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'https://picsum.photos/seed/180/600',
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),),
            ],
          ),
        ),
        SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Form(
                key: _formKey, // Assign the form key
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Weight of the Garbage';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select the Garbage Type';
                          }
                          return null;
                        },
                      ),
                    ),
                  if (!showQRCode)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await generateRewards(
                                textController1.text, textController2.text);
                          }
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
                          'Generate Reward QR',
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
        )]),
      ),
    );
  }
}
