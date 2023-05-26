import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/components/main_button.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/pages/login_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: AssetImage('images/bg.png'),
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  ThemeColors.scaffoldBgColor,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons
                              .directions_bus, // Replace with the desired bus icon
                          size: 30,
                          color: Color.fromARGB(255, 248, 215, 68),
                        ),
                        Text(
                          'Wheelie',
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 248, 215, 68),
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Track Your Van\nTo Ensure Your Child Is Safe.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.medium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: MainButton(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                        result: false,
                      ),
                      text: 'Get Started',
                      backgroundColor: Color.fromARGB(255, 248, 215, 68),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
