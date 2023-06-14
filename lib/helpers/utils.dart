import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:wheelie/pages/login_page.dart';

void _deleteDriverID(String driverId, BuildContext context) async {
  try {
    final driverRef =
        FirebaseFirestore.instance.collection('users').doc(driverId);
    final driverSnapshot = await driverRef.get();

    if (!driverSnapshot.exists) {
      print('Driver not found');
      return;
    }

    await driverRef.delete();
    print('Driver successfully deleted');

    // Show success message using ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Driver successfully deleted'),
      ),
    );
  } catch (e) {
    print('Error deleting driver: $e');
  }
}

Future<void> logout(BuildContext context) async {
  CircularProgressIndicator();
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
}
