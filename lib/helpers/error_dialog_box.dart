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

void userAlreadyRegistered(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          Icon(Icons.close, color: Colors.red),
          SizedBox(width: 8),
          Text(
            'Email Already Registered',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      content: Text(
        'The Entered Email Address is Already Registered.',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
