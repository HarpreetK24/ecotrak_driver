import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotrak_driver/dashboard_screen.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust this value
            ),
          ),
          SizedBox(height: defaultPadding), // Add this line for spacing
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person_outline),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust this value
            ),
          ),
          SizedBox(height: defaultPadding), // Add this line for spacing
          TextFormField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _phoneController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Phone Number",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding), // Adjust this value
                child: Icon(Icons.phone),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust this value
            ),
          ),
          SizedBox(height: defaultPadding), // Add this line for spacing
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding), // Adjust this value
                  child: Icon(Icons.lock),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust this value
              ),
            ),
          ),
          SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _signUpWithEmailAndPassword();
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          SizedBox(height: defaultPadding), // Add this line for spacing
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  Future<void> _signUpWithEmailAndPassword() async {
      try {
        final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(authResult.user?.uid).set({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
        });

        // If sign-up is successful, show a success notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up successful. You can now log in.'),
            duration: Duration(seconds: 3),
          ),
        );
        // Navigate to the dashboard after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } catch (e) {
        // Handle sign-up errors here
        print('Error signing up: $e');
        // Show an error notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing up. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }



}
