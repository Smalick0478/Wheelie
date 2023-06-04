import 'package:flutter/material.dart';

//Error Dialog box for Invalid Email/Password
void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(Icons.close, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Error Occurred',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          'Incorrect Email/Password',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Set button background color to black
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
