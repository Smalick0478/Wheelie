import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheelie/components/main_button.dart';
import 'package:wheelie/helpers/current_logged_person.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/helpers/utils.dart';
import 'package:wheelie/pages/login_page.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //profile variables
  late User? _user;
  File? _image;
  late String _imageUrl = '';
  final picker = ImagePicker();
  late String newProfilePicUrl = '';
  File? _licenseImage;
  File? _cnicImage;
  late String _licenseImageUrl = '';
  late String _cnicImageUrl = '';
  var fetchuserId;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    fetchCurrentUserID().then((id) {
      setState(() {
        fetchuserId = id;
      });
    });
  }

  @override
  void dispose() {
    _auth.signOut(); // Sign out the user
    super.dispose();
  }

  Future getLicenseImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _licenseImage = File(pickedFile.path);
        uploadLicenseImageToFirestoreStorage();
      }
    });
  }

  Future<void> uploadLicenseImageToFirestoreStorage() async {
    if (_licenseImage != null) {
      try {
        String? userId = _user?.uid;
        if (userId != null) {
          String fileName = 'driver_license_back/$userId.jpg';
          Reference reference = _storage.ref().child(fileName);
          await reference.putFile(_licenseImage!);
          String downloadUrl = await reference.getDownloadURL();

          // Update the driver license picture field in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'licensepic': downloadUrl});

          setState(() {
            _licenseImageUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('License Back Image uploaded successfully!',
                style: TextStyle(color: Colors.green)),
          ));
        }
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select License Back image first.',
            style: TextStyle(color: Colors.red)),
      ));
    }
  }

  Future getCnicImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _cnicImage = File(pickedFile.path);
        uploadCnicImageToFirestoreStorage();
      }
    });
  }

  Future<void> uploadCnicImageToFirestoreStorage() async {
    if (_cnicImage != null) {
      try {
        String? userId = _user?.uid;
        if (userId != null) {
          String fileName = 'driver_license_front/$userId.jpg';
          Reference reference = _storage.ref().child(fileName);
          await reference.putFile(_cnicImage!);
          String downloadUrl = await reference.getDownloadURL();

          // Update the driver cnic picture field in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'cnicpic': downloadUrl});

          setState(() {
            _cnicImageUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('License Front Image uploaded successfully!',
                style: TextStyle(color: Colors.green)),
          ));
        }
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select License Front image first.',
            style: TextStyle(color: Colors.red)),
      ));
    }
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

          // Update the driver's profile picture field in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'profilepic': downloadUrl});

          setState(() {
            _imageUrl = downloadUrl;
            newProfilePicUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Image uploaded successfully!',
                style: TextStyle(color: Colors.green)),
          ));
        }
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a Profile image first.',
            style: TextStyle(color: Colors.red)),
      ));
    }
  }

  Future<void> updateNameAndProfilePic(String newName, String newEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid;
    if (userId == null) {
      // No user logged in, handle the error or return
      return;
    }

    var userCollection = FirebaseFirestore.instance.collection('users');
    var userDoc = userCollection.doc(userId);

    await userDoc.update({
      'Name': newName,
      'email': newEmail,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fields Updated Successfully',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );
    }).catchError((error) {
      print('Error updating document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBgColor,
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(fetchuserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const CircularProgressIndicator();
            }

            var user = snapshot.data!.data() as Map<String, dynamic>? ?? {};
            if (user.isEmpty) {
              return const Text('User not found.');
            }

            var name = user['Name'] as String? ?? '';
            var email = user['email'] as String? ?? '';

            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Choose image source'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  GestureDetector(
                                    child: const Text('Camera'),
                                    onTap: () {
                                      getImageFromCamera();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const SizedBox(height: 30.0),
                                  GestureDetector(
                                    child: const Text('Gallery'),
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
                    child: FutureBuilder<String>(
                      future: fetchCurrentUserID(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data == 'Unknown') {
                          return const Text('No User found.');
                        }

                        var userId = snapshot.data;
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return const CircularProgressIndicator();
                            }

                            var user = snapshot.data!.data()
                                    as Map<String, dynamic>? ??
                                {};
                            if (user == null) {
                              return const Text('User not found.');
                            }

                            var name = user['Name'] as String? ?? '';
                            var email = user['email'] as String? ?? '';
                            var imageUrl = user['profilepic'] as String? ?? '';

                            return CircleAvatar(
                              radius: 80.0,
                              backgroundImage: (imageUrl != null)
                                  ? NetworkImage(imageUrl)
                                  : const AssetImage('images/avatar.png')
                                      as ImageProvider,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
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
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

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
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        Row(
                          children: [
                            //cnic field
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Choose License Front Image source'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: const Text('Camera'),
                                              onTap: () {
                                                getCnicImageFromCamera();
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
                              child: FutureBuilder<String>(
                                future: fetchCurrentUserID(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  String userId = snapshot.data!;
                                  return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return const CircularProgressIndicator();
                                      }

                                      var user = snapshot.data!.data()
                                              as Map<String, dynamic>? ??
                                          {};
                                      if (user == null) {
                                        return const Text('User not found.');
                                      }
                                      var _cnicImageUrl = user['cnicpic'];

                                      return Container(
                                        width: 160,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey[200],
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: (_cnicImageUrl != null)
                                                  ? Image.network(
                                                      _cnicImageUrl,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    )
                                                  : Image.asset(
                                                      'images/cnic.png',
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Choose License Front Image source'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              GestureDetector(
                                                                child: const Text(
                                                                    'Camera'),
                                                                onTap: () {
                                                                  getCnicImageFromCamera();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Text(
                                                    'Upload',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            //license field
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Choose License Back Image source'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: const Text('Camera'),
                                              onTap: () {
                                                getLicenseImageFromCamera();
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
                              child: FutureBuilder<String>(
                                future: fetchCurrentUserID(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  String userId = snapshot.data!;
                                  return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return const CircularProgressIndicator();
                                      }

                                      var user = snapshot.data!.data()
                                              as Map<String, dynamic>? ??
                                          {};

                                      var _licenseImageUrl = user['licensepic'];

                                      return Container(
                                        width: 160,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey[200],
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: (_licenseImageUrl != null)
                                                  ? Image.network(
                                                      _licenseImageUrl,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    )
                                                  : Image.asset(
                                                      'images/cnic.png',
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Choose License Back image source'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              GestureDetector(
                                                                child: const Text(
                                                                    'Camera'),
                                                                onTap: () {
                                                                  getLicenseImageFromCamera();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Text(
                                                    'Upload',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        MainButton(
                          text: 'Update',
                          backgroundColor: ThemeColors.YellowColor,
                          textColor: ThemeColors.titleColor,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              String newName = _nameController.text.trim();
                              String newEmail = _emailController.text.trim();

                              // Upload image to Firestore storage
                              // await uploadImageToFirestoreStorage();

                              // Update Firestore document
                              await updateNameAndProfilePic(newName, newEmail);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Fields Cannot be Empty',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        MainButton(
                          text: 'Logout',
                          backgroundColor: ThemeColors.textFieldBgColor,
                          onTap: () {
                            logout(context);
                          },
                        ),

                        const SizedBox(height: 70),
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
}
