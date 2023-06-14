import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/pages/login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  EmailVerificationPage({required this.email});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        backgroundColor: ThemeColors.YellowColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'A verification link has been sent to ${widget.email}.',
                style: const TextStyle(
                    fontSize: 18.0, color: ThemeColors.whiteTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Please check your email and click on the verification link to complete the registration process.',
                style: TextStyle(
                    fontSize: 16.0, color: ThemeColors.whiteTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: _firebaseAuth.currentUser != null
                    ? _checkVerificationStatus
                    : null,
                child: const Text(
                  'Check Verification Status',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.YellowColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkVerificationStatus() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        // Account is verified, proceed to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        Timer.periodic(const Duration(seconds: 1), (timer) async {
          await user.reload();
          if (user.emailVerified) {
            // Account is verified, cancel the timer and proceed to login
            timer.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        });
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Row(
                children: const [
                  Icon(Icons.close, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Account Not Verified',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Flexible(
                    child: Text(
                      'Please verify your email to log in.',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
