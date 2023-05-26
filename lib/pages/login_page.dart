import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/components/main_button.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//dashboards
import '../screens/dashboards/admin.dart';
import '../screens/dashboards/driver.dart';
import '../screens/dashboards/parent.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's get you in!",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Login to your account.",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 70),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ///Email Input Field
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.length == 0) {
                            return "Email cannot be empty";
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please enter a valid email");
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _emailController.text = value!;
                        },
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: ThemeColors.YellowColor,
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

                      ///Password Input Field
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (!regex.hasMatch(value)) {
                            return ("please enter valid password min. 6 character");
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _passwordController.text = value!;
                        },
                        obscureText: true,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: ThemeColors.YellowColor,
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
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.poppins(
                              color: ThemeColors.greyTextColor,
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      MainButton(
                        text: 'Login',
                        onTap: () {
                          _formKey.currentState!.validate();
                          signIn(
                              _emailController.text, _passwordController.text);
                        },
                        backgroundColor: ThemeColors.YellowColor,
                      ),
                      SizedBox(height: 16),
                      MainButton(
                        text: 'Login with Google',
                        backgroundColor: ThemeColors.whiteTextColor,
                        textColor: ThemeColors.scaffoldBgColor,
                        iconPath: 'images/google.png',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            color: ThemeColors.primaryColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Driver") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Driver(),
            ),
          );
        } else if (documentSnapshot.get('role') == "Parent") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Parent(),
            ),
          );
        } else if (documentSnapshot.get('role') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Admin(),
            ),
          );
        } else {
          print('Role Doesnt Exist');
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}