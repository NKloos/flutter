import 'package:cpd_ss23/login_page/login_screen.dart';
import 'package:cpd_ss23/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cpd_ss23/firebase_options.dart'; // Importieren Sie die Firebase-Optionen

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {/*

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseTestPage(),
    );
  }
}*/

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialisation,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  "JobFinder is being initialized",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Signatra',
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError && snapshot.hasData) {
          print('Firebase Error: ${snapshot.error}');
          print('Firebase hasData: ${snapshot.hasData}');
          print('Firebase ConnectionState: ${snapshot.connectionState}');
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Error: ${snapshot.error} AND ${snapshot.hasData} AND ${snapshot.connectionState}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "JobFinder App CPD_SS23",
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey,
            primarySwatch: Colors.blue,
          ),
          home: Login(),
        );
      },
    );
  }
}

