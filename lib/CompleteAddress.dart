import 'package:ecotrak_driver/Screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CompleteAddress extends StatefulWidget {
  const CompleteAddress({Key? key}) : super(key: key);

  @override
  _CompleteAddressState createState() => _CompleteAddressState();
}

class _CompleteAddressState extends State<CompleteAddress> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  String? selectedCity; // Selected city from the dropdown
  String? selectedState; // Selected state from the dropdown
  TextEditingController textController4 = TextEditingController();

  List<String> indianCities = [
    "Mumbai", "Delhi", "Bangalore", "Hyderabad", "Chennai", "Kolkata", "Pune", "Ahmedabad",
    "Jaipur", "Lucknow", "Chandigarh", "Kochi", "Bhopal", "Indore", "Kanpur", "Nagpur",
    "Varanasi", "Patna", "Coimbatore", "Visakhapatnam", "Surat", "Jaipur", "Udaipur",
    "Mysore", "Thiruvananthapuram",
  ];

  List<String> indianStates = [
    "Andhra Pradesh", "Arunachal Pradesh", "Assam","Bihar","Chhattisgarh","Goa",
    "Gujarat","Haryana","Himachal Pradesh","Jharkhand","Karnataka", "Kerala",
    "Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland",
    "Odisha","Punjab", "Rajasthan","Sikkim","Tamil Nadu", "Telangana", "Tripura",
    "Uttar Pradesh","Uttarakhand","West Bengal","Andaman and Nicobar Islands",
    "Chandigarh","Lakshadweep",
    "Delhi","Puducherry"
  ];

  bool showErrors = false; // Flag to control error message visibility

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    textController4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping outside of a text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent, // Set scaffold background to transparent
        body: Container(
          // Use a Container for the background
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_img.jpg"), // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            top: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Align(
                  alignment: AlignmentDirectional(-0.60, -1.06),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Make this container transparent
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-0.76, -0.94),
                          child: Text(
                            'Complete Address',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 391,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          SizedBox(height: 30.0),
                          buildTextFormField(
                            controller: textController1,
                            labelText: 'Enter your Building Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a building name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 17.0), // Added SizedBox for spacing
                          buildTextFormField(
                            controller: textController2,
                            labelText: 'Enter your Locality Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a locality name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 17.0),
                          buildDropdownFormField(
                            labelText: 'Select your City',
                            items: indianCities,
                            value: selectedCity,
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value;
                              });
                            },
                          ),
                          SizedBox(height: 17.0),
                          buildDropdownFormField(
                            labelText: 'Select your State',
                            items: indianStates,
                            value: selectedState,
                            onChanged: (value) {
                              setState(() {
                                selectedState = value;
                              });
                            },
                          ),
                          SizedBox(height: 17.0),
                          buildTextFormField(
                            controller: textController4,
                            labelText: 'Enter your Pincode',
                            //keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Pincode';
                              } else if (!_isValidIndianPincode(value)) {
                                return 'Invalid Indian Pincode';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.0),
                          Align(
                            alignment: Alignment(-0.08, 0.0),
                            child: TextButton(
                              onPressed: () {
                                _saveAddress();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 30,
                                ),
                                backgroundColor: Color(0xFF1FA525),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Save Address',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAddress() async {
    setState(() {
      // Toggle the flag to show/hide error messages
      showErrors = true;
    });

    if (_validateForm()) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is signed in, proceed to save address
        final String buildingName = textController1.text;
        final String localityName = textController2.text;
        final String city = selectedCity!;
        final String state = selectedState!;
        final String pincode = textController4.text;

        // Concatenate the data into a single address string
        final String address = '$buildingName, $localityName, $city, $state, $pincode';

        try {
          // Store the address in Firestore under the user's data
          await FirebaseFirestore.instance.collection('driver').doc(user.uid).update({
            'address': address,
          });

          // Address saved successfully
          print('Address saved: $address');

          // If sign-up is successful, show a success notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Address added successfully. '),
              duration: Duration(seconds: 3),
            ),
          );
          // Navigate to the dashboard after successful sign-up
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } catch (e) {
          // Handle any errors that occur during the save operation
          print('Error saving address: $e');
        }
      } else {
        // User is not signed in, handle accordingly
        print('User is not signed in.');
      }
    }
  }

  bool _validateForm() {
    // Validate all form fields
    bool isValid = true;

    if (textController1.text.isEmpty) {
      isValid = false;
    }

    if (textController2.text.isEmpty) {
      isValid = false;
    }

    if (selectedCity == null) {
      isValid = false;
    }

    if (selectedState == null) {
      isValid = false;
    }

    if (textController4.text.isEmpty || !_isValidIndianPincode(textController4.text)) {
      isValid = false;
    }

    return isValid;
  }

  bool _isValidIndianPincode(String pincode) {
    // Indian pincode has 6 digits
    if (pincode.length != 6) {
      return false;
    }

    // Check if all characters are digits
    if (!RegExp(r'^[0-9]+$').hasMatch(pincode)) {
      return false;
    }
    return true;
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            hintStyle: TextStyle(fontWeight: FontWeight.w500),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.redAccent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(fontWeight: FontWeight.w500),
          validator: validator,
        ),
        if (showErrors && validator != null && validator(controller.text) != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              validator(controller.text)!,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
      ],
    );
  }

  Widget buildDropdownFormField({
    required String labelText,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            hintStyle: TextStyle(fontWeight: FontWeight.w500),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.redAccent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}
