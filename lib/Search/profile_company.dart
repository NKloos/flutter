import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({required this.userId});

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

  void getUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phone');
          imageUrl = userDoc.get('userImage');
          joinedAt = userDoc.get('createdAt');
          location = userDoc.get('location');
          _nameController.text = name ?? '';
          _emailController.text = email ?? '';
          _phoneNumberController.text = phoneNumber ?? '';
          _locationController.text = location ?? '';
          _isLoading = false;
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
    } catch (error) {
      // Handle error
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
      _firestore.collection('users').doc(widget.userId).update({
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
        title: Text('Profile'),
        actions: [
          if (_isSameUser)
            IconButton(
              onPressed: _toggleEditMode,
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
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
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
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

                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        _isEditing && _isSameUser
                            ? TextFormField(
                          controller: _nameController,
                        )
                            : Text(name ?? ''),
                        SizedBox(height: 16),
                        Text(
                          'Email:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        _isEditing && _isSameUser
                            ? TextFormField(
                          controller: _emailController,
                        )
                            : Text(email ?? ''),
                        SizedBox(height: 16),
                        Text(
                          'Phone Number:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        _isEditing && _isSameUser
                            ? TextFormField(
                          controller: _phoneNumberController,
                        )
                            : Text(phoneNumber ?? ''),
                        SizedBox(height: 16),
                        Text(
                          'Location:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
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
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
