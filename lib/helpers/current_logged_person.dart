import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchCurrentUserName() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userData.exists) {
      return userData['name'];
    }
  }

  return 'Unknown'; // Return 'Unknown' if user or user data doesn't exist
}
