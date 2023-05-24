import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login.dart';

class FetchUserData {
  final String email;
  final String role;

  FetchUserData(this.email, this.role);
}

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<FetchUserData> users = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Registered Users",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final List<FetchUserData> users = snapshot.data!.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final email = data['email'] as String? ?? '';
                    final role = data['role'] as String? ?? '';

                    return FetchUserData(email, role);
                  })
                  .where(
                      (user) => user.role == 'Driver' || user.role == 'Parent')
                  .toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.email),
                      subtitle: Text(user.role),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
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
}
