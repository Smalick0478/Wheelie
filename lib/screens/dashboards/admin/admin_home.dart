import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/helpers/theme_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _currentDate;
  late String _currentTime;
  late Timer _clockTimer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _startClock();
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    setState(() {
      _currentDate = dateFormat.format(now);
      _currentTime = timeFormat.format(now);
    });
  }

  void _startClock() {
    // Update the time every minute
    _clockTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _updateDateTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentDate,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: ThemeColors.titleColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                _currentTime,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: ThemeColors.titleColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
