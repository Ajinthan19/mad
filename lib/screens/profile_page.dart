import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io'; // If you're using File for image picking
import 'package:image_picker/image_picker.dart'; // For picking images

class ProfilePage extends StatefulWidget {
  final String userName;

  ProfilePage({required this.userName});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = '';
  String phoneNumber = '';
  String fullName = '';
  String address = '';
  String profilePictureUrl = ''; // URL for the profile picture
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Fetch user details from the backend
    final response = await http.get(
      Uri.parse('http://192.168.1.2:8000/api/customer/details'), // Your API endpoint
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        fullName = data['full_name'] ?? 'N/A';
        email = data['email'] ?? 'N/A';
        phoneNumber = data['phone_number'] ?? 'N/A';
        address = data['address'] ?? 'N/A';
        profilePictureUrl = data['profile_picture'] ?? ''; // Assuming your backend sends the profile picture URL
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load user details: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user details')),
      );
    }
  }

  Future<void> _editProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Here you would typically upload the new image to your server
      // and update the profilePictureUrl accordingly.
      // For demonstration, we'll just update the UI with a local file path.
      setState(() {
        profilePictureUrl = image.path; // Update with the new image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _editProfilePicture,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profilePictureUrl.isNotEmpty
                      ? NetworkImage(profilePictureUrl) // Load from URL
                      : AssetImage('assets/images/review.png') as ImageProvider, // Placeholder
                  child: profilePictureUrl.isEmpty
                      ? Icon(Icons.camera_alt, size: 60, color: Colors.white)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileDetail('Username:', widget.userName),
            _buildProfileDetail('Full Name:', fullName),
            _buildProfileDetail('Email:', email),
            _buildProfileDetail('Phone Number:', phoneNumber),
            _buildProfileDetail('Address:', address),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/updateProfile',
                  arguments: widget.userName,
                );
              },
              child: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.indigo,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          Flexible(
            child: Text(
              detail,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
