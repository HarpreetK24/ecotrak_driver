import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _displayName = "";
  String _email = "";
  String _phoneNumber = "";
  String _address = "";

  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userData =
        await _firestore.collection('driver').doc(user.uid).get();

        setState(() {
          _displayName = userData['name'];
          _email = userData['email'];
          _phoneNumber = userData['phone'];
          _address = userData['address'];

          // Set initial values for the text input fields
          _displayNameController.text = _displayName;
          _emailController.text = _email;
          _phoneNumberController.text = _phoneNumber;
          _addressController.text = _address;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }



  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    // Save the changes to Firestore and update the displayed data
    _firestore.collection('driver').doc(_auth.currentUser!.uid).update({
      'name': _displayNameController.text,
      'email': _emailController.text,
      'phone': _phoneNumberController.text,
      'address': _addressController.text,
    });

    // Update the displayed data
    setState(() {
      _displayName = _displayNameController.text;
      _email = _emailController.text;
      _phoneNumber = _phoneNumberController.text;
      _address = _addressController.text;
      _isEditing = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.09,
                    right: screenWidth * 0.05,
                  ),
                  child: Container(
                    width: screenWidth * 0.95,
                    height: screenHeight * 0.85,
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
                              fontSize: screenWidth * 0.06,
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
                              width: screenWidth * 0.05,
                              height: screenHeight * 0.035,
                              fit: BoxFit.fitWidth,
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
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              61.5,
                              135,
                              0,
                              0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Text(
                                _displayName,
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.86, -0.38),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/phone-call.png',
                              width: screenWidth * 0.05,
                              height: screenHeight * 0.035,
                              fit: BoxFit.fitWidth,
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
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              63,
                              198,
                              0,
                              0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Text(
                                _phoneNumber,
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.83, -0.17),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/mail.png',
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.04,
                              fit: BoxFit.fitWidth,
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                              65,
                              268,
                              0,
                              0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Text(
                                _email,
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.84, 0.10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/maps-and-flags.png',
                              width: screenWidth * 0.06,
                              height: screenHeight * 0.035,
                              fit: BoxFit.fitWidth,
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

                            padding: EdgeInsetsDirectional.fromSTEB(
                                66,
                                342,
                                0,0
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Text(
                                _address,
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.18, -1.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFCAD999), Color(0xFF1AA51F)],
                        stops: [0, 1],
                        begin: AlignmentDirectional(0, -1),
                        end: AlignmentDirectional(0, 1),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.00, 0.00),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF009688),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.00, -0.81),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            30, 20, 20, 20),
                                        child: Text(
                                          'Hi '+ _displayName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.00, -0.16),
                                  child: GestureDetector(
                                    onTap: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.82,
                                          // bottom: screenHeight * 0.,
                                          top: screenHeight * 0
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          'https://picsum.photos/seed/180/600',
                                          width: screenWidth * 0.12,
                                          height: screenWidth * 0.12,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!_isEditing)
                Positioned(
                  bottom: 16.0, // Adjust the position as needed
                  right: 16.0, // Adjust the position as needed
                  child: FloatingActionButton(
                    onPressed: () {
                      _toggleEditing();
                    },
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.edit),
                  ),
                ),
              if (_isEditing)
                Positioned(
                  top: screenHeight * 0.2,
                  right: screenWidth * 0.05,
                  child: Container(
                    width: screenWidth * 0.95,
                    height: screenHeight * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      children: [
                        TextFormField(
                          controller: _displayNameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email Address'),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(labelText: 'Mobile Number'),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(labelText: 'Address'),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            _saveChanges();
                          },
                          child: Text('Save Changes'),
                        ),
                      ],
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