import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/components/main_button.dart';
import 'package:wheelie/helpers/error_dialog_box.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/no_internet_connection.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/pages/email_verification.dart';
import 'package:wheelie/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheelie/pages/reset_password.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

//dashboards
import 'package:wheelie/screens/dashboards/admin/admin.dart';
import 'package:wheelie/screens/dashboards/driver/driver.dart';
import 'package:wheelie/screens/dashboards/parent/parent.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isSigningIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var option = "OTP";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
                Row(
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.xxLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.account_circle_outlined,
                      color: ThemeColors.whiteTextColor,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Track Your Kids.",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Image(
                  image: AssetImage('images/loginbg.png'),
                  fit: BoxFit.contain,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          option = "Email";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: option == "Email"
                            ? ThemeColors.YellowColor
                            : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Login With Email',
                        style: TextStyle(
                          color: option == "Email"
                              ? ThemeColors.scaffoldBgColor
                              : ThemeColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          option = "OTP";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: option == "OTP"
                            ? ThemeColors.YellowColor
                            : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Login With OTP',
                        style: TextStyle(
                          color: option == "OTP"
                              ? ThemeColors.scaffoldBgColor
                              : ThemeColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (option == "Email")
                        Column(
                          children: [
                            ///Email Input Field
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.length == 0) {
                                  return "Email cannot be empty";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return "Please enter a valid email";
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
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            ///Password Input Field
                            TextFormField(
                              controller: _passwordController,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                if (!regex.hasMatch(value)) {
                                  return "Please enter a valid password with at least 6 characters";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _passwordController.text = value!;
                              },
                              obscureText:
                                  !_isPasswordVisible, // Toggle the visibility of password based on _isPasswordVisible
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
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PasswordResetPage(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromARGB(255, 12, 11, 12)),
                                  ),
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
                            ),
                          ],
                        ),
                      if (option == "OTP")
                        Column(
                          children: [
                            ///Phone Number Input Field
                            TextFormField(
                              controller: _phoneController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field can't be empty";
                                }
                                if (value.length != 13) {
                                  return "Phone Number must be 13 digits and\nStarts with country code +92";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _phoneController.text = value!;
                              },
                              style: GoogleFonts.poppins(
                                color: ThemeColors.whiteTextColor,
                              ),
                              keyboardType: TextInputType.phone,
                              maxLength: 13,
                              cursorColor: ThemeColors.YellowColor,
                              decoration: InputDecoration(
                                fillColor: ThemeColors.textFieldBgColor,
                                filled: true,
                                hintText: "Phone Number",
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
                              onChanged: (value) {
                                String phoneNumber = value;

                                // Remove any non-digit characters except the '+' sign
                                phoneNumber = phoneNumber.replaceAll(
                                    RegExp(r'[^+\d]'), '');

                                // Add country code prefix if the number starts with '0'
                                if (phoneNumber.isNotEmpty &&
                                    phoneNumber[0] != '+') {
                                  phoneNumber =
                                      '+92${phoneNumber.substring(1)}';
                                }

                                _phoneController.value =
                                    _phoneController.value.copyWith(
                                  text: phoneNumber,
                                  selection: TextSelection.collapsed(
                                      offset: phoneNumber.length),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      const SizedBox(height: 25),
                      Stack(
                        children: [
                          MainButton(
                            text: _isSigningIn
                                ? ''
                                : (option == "Email" ? 'Login' : 'Verify OTP'),
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (option == "Email") {
                                  setState(() {
                                    _isSigningIn = true;
                                  });
                                  bool success = await signInWithEmail(
                                    context,
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                } else if (option == "OTP") {
                                  setState(() {
                                    _isSigningIn = true;
                                  });
                                  bool success = await verifyOTP(
                                    _phoneController.text,
                                  );
                                }
                              }
                            },
                            backgroundColor: ThemeColors.YellowColor,
                            // Conditional statement to show/hide CircularProgressIndicator
                            textColor: _isSigningIn ? Colors.transparent : null,
                          ),
                          if (_isSigningIn)
                            const Positioned.fill(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
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
                            builder: (context) => const SignUpPage(),
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

  void route(String role) {
    if (role == "Driver") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DriverDashboard(),
        ),
      );
    } else if (role == "Parent") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Parent(),
        ),
      );
    } else if (role == "Admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminDashboard(),
        ),
      );
    } else {
      print('Role Doesnt Exist');
    }
  }

  Future<bool> signInWithEmail(
      BuildContext context, String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        bool isConnected = await InternetConnectionChecker().hasConnection;
        if (isConnected) {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            var snapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

            if (snapshot.exists) {
              bool isEmailVerified = user.emailVerified;

              if (isEmailVerified) {
                String role = snapshot.get('role');

                route(role);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailVerificationPage(email: email),
                  ),
                );
              }
            } else {
              print('User document does not exist in the database');
            }
          } else {
            print('User is null');
          }

          return true;
        } else {
          noInternetConnection(context);
          return false;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showIncorrectUserErrorDialog(context);
          setState(() {
            _isSigningIn = false;
          });
        } else if (e.code == 'wrong-password') {
          showIncorrectUserErrorDialog(context);
          setState(() {
            _isSigningIn = false;
          });
        }
        return false;
      }
    }
    return false;
  }

  Future<bool> verifyOTP(String phoneNumber) async {
    if (_formKey.currentState!.validate()) {
      try {
        bool isConnected = await InternetConnectionChecker().hasConnection;
        if (isConnected) {
          String phone = _phoneController.text
              .trim(); // Use the value from _phoneController

          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phone,
            verificationCompleted: (PhoneAuthCredential credential) async {},
            verificationFailed: (FirebaseAuthException e) {
              showOTPErrorDialog(context);
              setState(() {
                _isSigningIn = false;
              });
            },
            codeSent: (String verificationId, int? resendToken) {
              showOTPDInputDialog(verificationId);
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );

          return true;
        } else {
          noInternetConnection(context);
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }

  void showOTPDInputDialog(String verificationId) {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColors.scaffoldBgColor,
          title: const Text(
            'Enter OTP',
            style: TextStyle(color: Colors.white),
          ),
          content: TextFormField(
            controller: otpController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
            ),
            decoration: InputDecoration(
              fillColor: ThemeColors.textFieldBgColor,
              filled: true,
              hintText: "Enter OTP...",
              hintStyle: GoogleFonts.poppins(
                color: ThemeColors.textFieldHintColor,
                fontSize: FontSize.medium,
                fontWeight: FontWeight.w400,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
            cursorColor: ThemeColors.YellowColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter OTP';
              }
              return null;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Submit',
                style: TextStyle(color: ThemeColors.YellowColor),
              ),
              onPressed: () async {
                String otp = otpController.text.trim();
                if (_formKey.currentState!.validate()) {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otp,
                  );
                  await FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((UserCredential userCredential) async {
                    User? user = userCredential.user;
                    if (user != null) {
                      String phoneNumber = user.phoneNumber!;

                      // Check if the mobile number exists in registered email
                      var querySnapshot = await FirebaseFirestore.instance
                          .collection('users')
                          .where('Phone', isEqualTo: phoneNumber)
                          .get();

                      if (querySnapshot.size > 0) {
                        // User with matching mobile number found in email authentication
                        String email = querySnapshot.docs[0].get('email');
                        String password = querySnapshot.docs[0].get('password');

                        // Sign in with the email and password
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // Retrieve the email authenticated user
                        User? emailUser = FirebaseAuth.instance.currentUser;

                        if (emailUser != null) {
                          // Use the email authenticated user ID for further operations
                          String emailUserId = emailUser.uid;

                          // Retrieve the user document based on the email user ID
                          var userData = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(emailUserId)
                              .get();

                          if (userData.exists) {
                            String role = userData.get('role');
                            route(role);
                          } else {
                            print(
                                'User document does not exist in the database');
                          }
                        } else {
                          print('Email authenticated user is null');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Mobile number does not exist in registered email',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                    } else {
                      print('User is null');
                    }
                  }).catchError((error) {
                    showOTPErrorDialog(context);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
