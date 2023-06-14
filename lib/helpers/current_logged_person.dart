import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<String> fetchCurrentUserName() {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final useremail =
        FirebaseFirestore.instance.collection('users').doc(user.email);
    final userphone =
        FirebaseFirestore.instance.collection('users').doc(user.phoneNumber);

    return userDoc.snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot['Name'];
      } else {
        return 'Unknown';
      }
    });
  }

  return Stream.value('Unknown');
}

Future<String> fetchCurrentUserEmail() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userData.exists) {
      return userData['email'];
    }
  }

  return 'Unknown'; // Return 'Unknown' if user or user data doesn't exist
}

Future<String> fetchCurrentUserID() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    return user.uid;
  }

  return 'Unknown'; // Return 'Unknown' if user is null
}
