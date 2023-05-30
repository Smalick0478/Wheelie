import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/pages/start_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(_animationController);
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _animationController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Wheelie',
                  style: GoogleFonts.poppins(
                    color: ThemeColors.YellowColor,
                    fontSize: FontSize.xxxLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'A Smart Way To Track Your Child\'s Bus',
                  style: GoogleFonts.poppins(
                    color: ThemeColors.YellowColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'images/loginbg.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
