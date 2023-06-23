import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTestPage extends StatefulWidget {
  @override
  _FirebaseTestPageState createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
      print('Firebase Initialization Error: $e');
    }
  }

  Future<void> testFirebaseAuth() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print(
          'Firebase Authentication Successful. User ID: ${userCredential.user?.uid}');
    } catch (e) {
      print('Firebase Authentication Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Scaffold(
        body: Center(
          child: Text('Firebase Initialization Error'),
        ),
      );
    }

    if (!_initialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Test Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: testFirebaseAuth,
          child: Text('Test Firebase Auth'),
        ),
      ),
    );
  }
}
