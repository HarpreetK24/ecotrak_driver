import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _profileImage != null
                ? CircleAvatar(
              radius: 80,
              backgroundImage: FileImage(_profileImage!),
            )
                : CircleAvatar(
              radius: 80,
              child: Icon(Icons.person, size: 80),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Choose Image'),
            ),
            SizedBox(height: 16),
            // Other profile-related fields...
          ],
        ),
      ),
    );
  }
}
