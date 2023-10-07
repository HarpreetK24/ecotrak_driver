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

    return Scaffold(
      backgroundColor: Color(0xFFE1F5FE),
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
                    true ? 'My Profile'  : '',
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
                        ),
                      ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(-0.04, 0.92),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight *0,
                        right: screenWidth * 0.05,
                      ),
                      child: Container(
                        width: screenWidth * 0.95,
                        height: screenHeight * 0.775,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
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
                                  fontWeight: FontWeight.w800,
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
                                  height: screenHeight * 5,
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
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-0.48, -0.32),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  63,
                                  195,
                                  0,
                                  0,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 5,
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
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.44, -0.09),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  65,
                                  265,
                                  0,
                                  0,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 5,
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
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-0.11, 0.15),
                              child: Padding(

                                padding: EdgeInsetsDirectional.fromSTEB(
                                    66,
                                    335,
                                    0,0
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 5,
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
                  if (!_isEditing)
                    Positioned(
                      bottom: screenHeight * 0.02, // Adjust the position as needed
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
                      top: screenHeight * 0.01,
                      right: screenWidth * 0.05,
                      child: Container(
                        width: screenWidth * 0.95,
                        height: screenHeight * 0.85,
                        decoration: BoxDecoration(
                          color: Color(0xFFE1F5FE),
                        ),
                        child: ListView(
                          padding: EdgeInsets.all(16.0),
                          children: [
                            TextFormField(
                              controller: _displayNameController,
                              decoration: InputDecoration(labelText: 'Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
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
                                fillColor: Color(0xFFE1F5FE),),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(labelText: 'Email Address',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
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
                                fillColor: Color(0xFFE1F5FE),),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: InputDecoration(labelText: 'Mobile Number',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
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
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
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
                                fillColor: Color(0xFFE1F5FE),),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(

                              onPressed: () {
                                _saveChanges();
                              },style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF009688),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity, 55),),
                              child: Text('Save Changes'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ]),
      ),
    );
  }
}