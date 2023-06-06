import 'package:cpd_ss23/jobs/jobs_screen.dart';
import 'package:cpd_ss23/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page/login_screen.dart';

class UserState extends StatelessWidget {//  enthält keine internen Variablen, die sich während der Laufzeit ändern können.


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:FirebaseAuth.instance.authStateChanges(),builder: (context, userSnapshot){
        if(userSnapshot.data == null){
          print('user isnt logged in yet');
          return Login();
        }
        else if(userSnapshot.hasData){
          print('user is already logged in ');
          return JobScreen();
        }
        else if(userSnapshot.hasError){
          return const Scaffold(
            body: Center(
              child:Text("An Error ossured"),
            )
          );
        }
        else if(userSnapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
              body: Center(
                child:CircularProgressIndicator(),
              )
          );
        }
        return const Scaffold(body:Center(
          child:Text( "Smt went wrong"),
        ));
    },

    );
  }
}
