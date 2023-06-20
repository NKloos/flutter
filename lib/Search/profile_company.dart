import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Widgets/bottom_nav_bar.dart';
import '../services/global_variables.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;

  const ProfileScreen({required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  String? name;
  String? email;
  String? phoneNumber;
  String? imageUrl;
  String? joinedAt;
  String? location;
  bool _isLoading = false;
  bool _isSameUser = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void _sendEmail() async {
    {
      final Uri params = Uri(
        scheme: "mailto",
        path: email,
        query:
        "subject=Hey from JobFinder",
      );
      final url = params.toString();
      launchUrlString(url);
    }
  }

  void getUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phone');
          imageUrl = userDoc.get('userImage');
          location = userDoc.get('location');

          _nameController.text = name ?? '';
          _emailController.text = email ?? '';
          _phoneNumberController.text = phoneNumber ?? '';
          _locationController.text = location ?? '';
          _isLoading = false;
          final timestamp = userDoc.get('createdAt');
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      } else {
        print('User not found');
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleEditMode() {
    if (_isSameUser) {
      setState(() {
        _isEditing = !_isEditing;
      });
    }
    setState(() {});
  }

  void _saveChanges() {
    setState(() {
      name = _nameController.text;
      email = _emailController.text;
      phoneNumber = _phoneNumberController.text;
      location = _locationController.text;
      _toggleEditMode();
    });

    // Update data in Firebase
    if (_isSameUser) {
      _firestore.collection('users').doc(widget.userID).update({
        'name': name,
        'email': email,
        'phone': phoneNumber,
        'location': location,
      }).then((value) {
        // Success
      }).catchError((error) {
        // Handle error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_isSameUser)
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text(_isEditing ? 'Save' : 'Edit'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          if (!_isSameUser && email != null)
            IconButton(
              onPressed: _sendEmail,
              icon: const Icon(Icons.mail),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.white60],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.2, 0.9],
          ),
        ),
        child: Stack(

          children: [
          Image.network(
          signupUrlImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/signup.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Name:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _isEditing && _isSameUser
                            ? TextFormField(
                                controller: _nameController,
                              )
                            : Text(name ?? ''),
                        const SizedBox(height: 16),
                        const Text(
                          'Email:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _isEditing && _isSameUser
                            ? TextFormField(
                                controller: _emailController,
                              )
                            : Text(email ?? ''),
                        const SizedBox(height: 16),
                        const Text(
                          'Phone Number:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _isEditing && _isSameUser
                            ? TextFormField(
                                controller: _phoneNumberController,
                              )
                            : Text(phoneNumber ?? ''),
                        const SizedBox(height: 16),
                        const Text(
                          'Location:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _isEditing && _isSameUser
                            ? TextFormField(
                                controller: _locationController,
                              )
                            : Text(location ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
