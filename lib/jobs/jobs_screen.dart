import 'package:cpd_ss23/Widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/global_variables.dart';
import '../user_state.dart';

class JobScreen extends StatefulWidget {
  @override
  State<JobScreen> createState() => _JobScreenState();
}

final _auth = FirebaseAuth.instance;

class _JobScreenState extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum:0),
      body: Stack(
        children: [
          Image.network(
            signupUrlImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: size.height - 18, // Adjust for bottom overflow
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.cyan,
                    title: const Text('Job Screen'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          // Action when the search icon is clicked
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      _auth.signOut();
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => UserState()),
                      );
                    },
                    child: const Text("Log Out"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
