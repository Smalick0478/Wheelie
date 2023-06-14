import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/components/main_button.dart';
import 'package:wheelie/helpers/error_dialog_box.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isSubmitting = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        forgotPasswordLinkSent(context);
      } catch (e) {
        forgotPasswordLinkSentError(context);
      }
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 30, 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Your Email",
                style: GoogleFonts.poppins(
                  color: ThemeColors.whiteTextColor,
                  fontSize: FontSize.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),

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

              //Password Input Field

              SizedBox(height: 70),
              MainButton(
                text: 'Forgot Password',
                onTap: () {
                  _formKey.currentState!.validate();
                  _resetPassword();
                },
                backgroundColor: ThemeColors.YellowColor,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
