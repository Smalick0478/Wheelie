import 'package:flutter/material.dart';

Future<dynamic> noInternetConnection(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          Icon(Icons.close, color: Colors.red),
          SizedBox(width: 8),
          Text('No Internet Connection', style: TextStyle(color: Colors.white)),
        ],
      ),
      content: Text(
        'Please check your internet connection and try again.',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
