import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/theme_colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> updateNameAndProfilePic(
      String newName, String newProfilePicUrl) async {
    var userCollection = FirebaseFirestore.instance.collection('users');
    var querySnapshot =
        await userCollection.where('role', isEqualTo: 'Admin').limit(1).get();

    if (querySnapshot.docs.isEmpty) {
      // No admin user found, create a new document
      await userCollection.add({
        'name': newName,
        'profilepic': newProfilePicUrl,
        'role': 'Admin',
      });
    } else {
      // Admin user found, update the existing document
      var docId = querySnapshot.docs.first.id;
      await userCollection.doc(docId).update({
        'name': newName,
        'profilepic': newProfilePicUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Admin')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return CircularProgressIndicator();
          }

          var documents = snapshot.data?.docs;
          if (documents == null || documents.isEmpty) {
            return Text('No admin user found.');
          }

          var user = documents[0].data();
          var name = user['name'];
          var email = user['email'];

          return Center(
            child: Column(
              children: [
                SizedBox(height: 150.0),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Choose image source'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                GestureDetector(
                                  child: Text('Camera'),
                                  onTap: () {
                                    getImageFromCamera();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  child: Text('Gallery'),
                                  onTap: () {
                                    getImageFromGallery();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: _image != null
                        ? Image.file(_image!).image
                        : NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Name: $name',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: ThemeColors.titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Email: $email',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: ThemeColors.titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final nameController =
                            TextEditingController(text: name);
                        final emailController =
                            TextEditingController(text: email);

                        return AlertDialog(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          title: Text(
                            'Update Profile',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field can't be empty";
                                  }
                                  return null;
                                },
                                style: GoogleFonts.poppins(
                                  color: ThemeColors.whiteTextColor,
                                ),
                                keyboardType: TextInputType.name,
                                cursorColor: ThemeColors.primaryColor,
                                decoration: InputDecoration(
                                  fillColor: ThemeColors.textFieldBgColor,
                                  filled: true,
                                  hintText: "Full name",
                                  hintStyle: GoogleFonts.poppins(
                                    color: ThemeColors.textFieldHintColor,
                                    fontSize: FontSize.medium,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email cannot be empty";
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please enter a valid email");
                                  }
                                  return null;
                                },
                                style: GoogleFonts.poppins(
                                  color: ThemeColors.whiteTextColor,
                                ),
                                keyboardType: TextInputType.name,
                                cursorColor: ThemeColors.primaryColor,
                                decoration: InputDecoration(
                                  fillColor: ThemeColors.textFieldBgColor,
                                  filled: true,
                                  hintText: "Email",
                                  hintStyle: GoogleFonts.poppins(
                                    color: ThemeColors.textFieldHintColor,
                                    fontSize: FontSize.medium,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: ThemeColors.whiteTextColor),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                String newName = nameController.text.trim();
                                String newEmail = emailController.text.trim();

                                // Update Firestore document
                                updateNameAndProfilePic(newName, newEmail);

                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Update',
                                style:
                                    TextStyle(color: ThemeColors.YellowColor),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Edit Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
