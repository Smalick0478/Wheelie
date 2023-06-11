import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/components/main_button.dart';
import 'package:wheelie/helpers/cnic_formatter.dart';
import 'package:wheelie/helpers/error_dialog_box.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/no_internet_connection.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/pages/login_page.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cnicController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  var role = "Driver";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New here? Welcome!",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Please fill the form to continue.",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          role = "Driver";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: role == "Driver"
                            ? ThemeColors.YellowColor
                            : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'As a Driver',
                        style: TextStyle(
                          color: role == "Driver"
                              ? ThemeColors.scaffoldBgColor
                              : ThemeColors.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          role = "Parent";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: role == "Parent"
                            ? ThemeColors.YellowColor
                            : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'As a Parent',
                        style: TextStyle(
                          color: role == "Parent"
                              ? ThemeColors.scaffoldBgColor
                              : ThemeColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70),
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
                          hintText: "Full name",
                          hintStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
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
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
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
                          hintText: "E-mail",
                          hintStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      ///Phone Input Field
                      TextFormField(
                        controller: _phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field can't be empty";
                          }
                          if (value.length != 11) {
                            return "Phone number must be 11 digits";
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        cursorColor: ThemeColors.primaryColor,
                        keyboardType: TextInputType.phone,
                        maxLength:
                            11, // Set the maximum length to 11 characters
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          hintText: "Phone number",
                          hintStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),

                      //CNIC Input Field
                      if (role == "Driver")
                        Column(
                          children: [
                            TextFormField(
                              controller: _cnicController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field can't be empty";
                                }
                                return null;
                              },
                              style: GoogleFonts.poppins(
                                color: ThemeColors.whiteTextColor,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(13),
                                CNICNumberFormatter(), // Custom formatter for CNIC number
                              ],
                              cursorColor: ThemeColors.primaryColor,
                              decoration: InputDecoration(
                                fillColor: ThemeColors.textFieldBgColor,
                                filled: true,
                                hintText: "CNIC number",
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
                          ],
                        ),

                      ///Password Input Field
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (!regex.hasMatch(value)) {
                            return "Please enter a valid password (min. 6 characters)";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _passwordController.text = value!;
                        },
                        obscureText: !_isPasswordVisible,
                        autocorrect: false,
                        enableSuggestions: false,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          hintText: "Password",
                          hintStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            child: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: ThemeColors.textFieldHintColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmpasswordController,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Password did not match";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _passwordController.text = value!;
                        },
                        obscureText: !_isConfirmPasswordVisible,
                        autocorrect: false,
                        enableSuggestions: false,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          hintText: "Confirm Password",
                          hintStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            child: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: ThemeColors.textFieldHintColor,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 70),
                      MainButton(
                        text: 'Sign Up',
                        backgroundColor: ThemeColors.YellowColor,
                        onTap: () {
                          signUp(
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text,
                              _cnicController.text,
                              role);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String fullname, String email, String phone, String password,
      String cnic, String role) async {
    if (_formKey.currentState!.validate()) {
      try {
        bool userExists = await isUserExistsInFirestore(email);

        if (!userExists) {
          // User is a new user, proceed with registration
          final result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          if (result.additionalUserInfo!.isNewUser) {
            // Store user details in Firestore
            postDetailsToFirestore(fullname, email, phone, role, cnic);
          }

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          // User is already registered, show dialog box
          userAlreadyRegistered(context);
        }
      } catch (e) {
        // Handle registration error
        noInternetConnection(context);
      }
    }
  }

  void postDetailsToFirestore(String fullname, String email, String phone,
      String role, String cnic) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference ref = firebaseFirestore.collection('users');

    if (role == "Driver") {
      await ref.doc(user!.uid).set({
        'Name': fullname,
        'email': email,
        'Phone': phone,
        'cnic': cnic,
        'role': role,
      });
    } else if (role == "Parent") {
      await ref.doc(user!.uid).set({
        'Name': fullname,
        'email': email,
        'Phone': phone,
        'role': role,
      });
    }
  }

  Future<bool> isUserExistsInFirestore(String email) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    var querySnapshot =
        await usersCollection.where('email', isEqualTo: email).limit(1).get();

    return querySnapshot.docs.isNotEmpty; // Returns true if the user exists
  }
}
