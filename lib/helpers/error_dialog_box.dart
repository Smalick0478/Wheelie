import 'package:flutter/material.dart';

//Error Dialog box for Invalid Email/Password
void showIncorrectUserErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(Icons.close, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Error Occurred',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          'Incorrect Email/Password',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.black, // Set button background color to black
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(Icons.close, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Error Occurred',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          'Unknown Error Occurred\nTry Again Later',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.black, // Set button background color to black
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

void showOTPErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(Icons.close, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Error Occurred',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Wrap(
          children: const [
            Text(
              'OTP Quota Exceeded\nTry Again Later',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.black, // Set button background color to black
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

void forgotPasswordLinkSent(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text(
              'Email Sent',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Wrap(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'A password reset link has been sent to your email address.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.black, // Set button background color to black
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white, // Set button text color to white
              ),
            ),
          ),
        ],
      );
    },
  );
}

void forgotPasswordLinkSentError(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text(
              'Error Occurred',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Wrap(
          children: const [
            Text(
              'An error occurred while resetting your password. Please try again later.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.black, // Set button background color to black
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white, // Set button text color to white
              ),
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
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(Icons.close, color: Colors.red),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Email/Phone Already Registered',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: Wrap(
          children: const [
            Text(
              'The Entered Email Address or Phone is Already Registered.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
