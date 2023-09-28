import 'dart:io';
import 'package:flutter/material.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   File? _profileImage;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 35,
//                   backgroundImage: _profileImage != null
//                       ? FileImage(_profileImage!)
//                       :Image.asset("assets/images/donate-blood-collage-coronavirus-icons-vector-30596014.png").image,
//                 ),
//                 const SizedBox(width: 16),
//                 const Column(
//                   children: [
//                     Text(
//                       'Harpreet',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Text(
//                       'Driver',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // ElevatedButton(
//             //   onPressed: () => _pickImage(ImageSource.gallery),
//             //   child: const Text('Choose Image'),
//             // ),
//             const SizedBox(height: 16),
//             // Other profile-related fields...
//           ],
//         ),
//       ),
//     );
//   }
// }


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,

          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(-0.04, 0.92),
                child: Padding(
                  padding: EdgeInsets.only(top: 250.0), // Add this line
                  child: Container(
                    width: 368,
                    height: 550,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-0.83, -0.86),
                          child: Text(
                            'Account Info',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.88, -0.60),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/user.png',
                              width: 30,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.60, -0.62),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.60, -0.62),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.50, -0.55),
                          child: Text(
                            'Nitish Churiwala',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.86, -0.38),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/phone-call.png',
                              width: 30,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.49, -0.41),
                          child: Text(
                            'Mobile Number',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.48, -0.32),
                          child: Text(
                            '+919632587416',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.83, -0.17),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/mail.png',
                              width: 32,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.49, -0.17),
                          child: Text(
                            'Email Address',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.44, -0.09),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 18, 0),
                            child: Text(
                              'nitish.churiwala@bca.christuniversity.in',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),),
                        Align(
                          alignment: AlignmentDirectional(-0.84, 0.10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/maps-and-flags.png',
                              width: 32,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.55, 0.07),
                          child: Text(
                            'Address',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.11, 0.15),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 18, 0),
                            child: Text(
                              'Kalpavriksha Student Housing',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.18, -1.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                  child: Container(
                    width: 368,
                    height: 251,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF88AF76), Color(0xFF1AA51F)],
                        stops: [0, 1],
                        begin: AlignmentDirectional(0, -1),
                        end: AlignmentDirectional(0, 1),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.00, -0.16),
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(135, 0, 135, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                'https://picsum.photos/seed/180/600',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.00, 0.61),
                          child: Text(
                            'Nitish Churiwala',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.03, 0.85),
                          child: Text(
                            'Consumer',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}