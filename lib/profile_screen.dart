import 'dart:io';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      :Image.asset("assets/images/donate-blood-collage-coronavirus-icons-vector-30596014.png").image,
                ),
                const SizedBox(width: 16),
                const Column(
                  children: [
                    Text(
                      'Harpreet',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Driver',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () => _pickImage(ImageSource.gallery),
            //   child: const Text('Choose Image'),
            // ),
            const SizedBox(height: 16),
            // Other profile-related fields...
          ],
        ),
      ),
    );
  }
}