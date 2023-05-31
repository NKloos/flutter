// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class GlobalMethod{
  static void showErrorDialog({required String error, required BuildContext ctx}) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title:  Row (
            children:  const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout, color: Colors.grey, size: 35),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Error Occured'),
              ),
            ],
          ),
          content: Text(
            error,
            style: const TextStyle(
              color: Colors.black12,
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;  //  Zurücknavigieren, falls möglich

              },
              child: const Text(
                'oki doki',
                style: TextStyle(color: Colors.redAccent, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
  static void getPicture(){

  }
}
