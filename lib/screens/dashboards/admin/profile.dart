import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheelie/components/main_button.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/pages/login_page.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late User? _user;
  File? _image;
  late String _imageUrl = '';
  final picker = ImagePicker();
  late String newProfilePicUrl = '';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  void dispose() {
    _auth.signOut(); // Sign out the user
    super.dispose();
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImageToFirestoreStorage();
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImageToFirestoreStorage();
      }
    });
  }

  Future<void> uploadImageToFirestoreStorage() async {
    if (_image != null) {
      try {
        String? userId = _user?.uid;
        if (userId != null) {
          String fileName = 'profile_images/$userId.jpg';
          Reference reference = _storage.ref().child(fileName);
          await reference.putFile(_image!);
          String downloadUrl = await reference.getDownloadURL();

          // Update the admin's profile picture field in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'profilepic': downloadUrl});

          setState(() {
            _imageUrl = downloadUrl;
            newProfilePicUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Image uploaded successfully!',
                style: TextStyle(color: Colors.green)),
          ));
        }
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select an image first.',
            style: TextStyle(color: Colors.red)),
      ));
    }
  }

  Future<void> updateNameAndProfilePic(
      String newName, String newEmail, String newProfilePicUrl) async {
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
        'email': newEmail,
        'profilepic': newProfilePicUrl, // Use newProfilePicUrl here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBgColor,
      body: SingleChildScrollView(
        child: StreamBuilder(
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
                  SizedBox(height: 50.0),
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
                                  SizedBox(height: 30.0),
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
                    child: StreamBuilder(
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
                        var imageUrl = user['profilepic'];

                        return CircleAvatar(
                          radius: 80.0,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : AssetImage('images/avatar.png')
                                  as ImageProvider,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ///Name Input Field
                        TextFormField(
                          controller: _nameController,
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
                            hintText: "Name: $name",
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

                        ///E-mail Input Field
                        TextFormField(
                          controller: _emailController,
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
                          cursorColor: ThemeColors.primaryColor,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            fillColor: ThemeColors.textFieldBgColor,
                            filled: true,
                            hintText: "Email: $email",
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
                        SizedBox(height: 30),

                        MainButton(
                          text: 'Update',
                          backgroundColor: ThemeColors.YellowColor,
                          textColor: ThemeColors.titleColor,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              String newName = _nameController.text.trim();
                              String newEmail = _emailController.text.trim();

                              // Upload image to Firestore storage
                              await uploadImageToFirestoreStorage();

                              // Update Firestore document
                              updateNameAndProfilePic(
                                  newName, newEmail, newProfilePicUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Fields Cannot be Empty'),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20),

                        MainButton(
                          text: 'Logout',
                          backgroundColor: ThemeColors.textFieldBgColor,
                          onTap: () {
                            logout(context);
                          },
                        ),

                        SizedBox(height: 70),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
