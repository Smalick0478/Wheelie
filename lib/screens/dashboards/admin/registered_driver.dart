import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelie/helpers/font_size.dart';
import 'package:wheelie/helpers/theme_colors.dart';
import 'package:wheelie/screens/dashboards/admin/cnic_formatter.dart';
import 'package:flutter/services.dart';

class RegisteredDriverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.scaffoldBgColor,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Driver')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final drivers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  DriverCard(driver: drivers[index]),
                  SizedBox(height: 16),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class DriverCard extends StatelessWidget {
  final QueryDocumentSnapshot driver;

  const DriverCard({required this.driver});

  @override
  Widget build(BuildContext context) {
    if (!driver.exists) {
      // Handle the case where the document doesn't exist
      return SizedBox();
    }

    final data = driver.data() as Map<String, dynamic>?;

    final driverName = data?['Name'] as String?;
    final driverEmail = data?['email'] as String?;

    if (driverName == null || driverEmail == null) {
      // Handle the case where the necessary data is missing
      return SizedBox();
    }

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.textFieldBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        color: ThemeColors
            .textFieldBgColor, // Set the card color to match the container color
        child: ListTile(
          title: Text(
            driverName,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            driverEmail,
            style: TextStyle(color: Colors.white),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteDriver(driver.id);
                },
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () {
                  _updateDriver(context, driver);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteDriver(String driverId) async {
    try {
      final driverRef =
          FirebaseFirestore.instance.collection('users').doc(driverId);
      final driverSnapshot = await driverRef.get();

      if (!driverSnapshot.exists) {
        print('Driver not found');
        return;
      }

      await driverRef.delete();
      print('Driver successfully deleted');
    } catch (e) {
      print('Error deleting driver: $e');
    }
  }

  void _updateDriver(BuildContext context, QueryDocumentSnapshot driver) {
    final driverId = driver.id;
    final data = driver.data() as Map<String, dynamic>;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final currentName = data['Name'] as String?;
    final currentEmail = data['email'] as String?;
    final currentPhone = data['Phone'] as String?;
    final currentCnic = data['cnic'] as String?;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedName = currentName ?? '';
        String updatedEmail = currentEmail ?? '';
        String updatedPhone = currentPhone ?? '';
        String updatedCnic = currentCnic ?? '';

        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Update Driver',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: updatedName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      updatedName = value;
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
                  TextFormField(
                    initialValue: updatedEmail,
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
                    onChanged: (value) {
                      updatedEmail = value;
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
                  TextFormField(
                    initialValue: updatedPhone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                      if (value.length != 11) {
                        return "Phone number must be 11 digits";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      updatedPhone = value;
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                    cursorColor: ThemeColors.primaryColor,
                    keyboardType: TextInputType.phone,
                    maxLength: 11, // Set the maximum length to 11 characters
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
                  TextFormField(
                    initialValue: updatedCnic,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      updatedCnic = value;
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
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Update',
                style: TextStyle(color: ThemeColors.YellowColor),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();

                  final updatedData = {
                    'Name': updatedName,
                    'email': updatedEmail,
                    'Phone': updatedPhone,
                    'cnic': updatedCnic,
                  };

                  try {
                    final driverRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(driverId);
                    final driverSnapshot = await driverRef.get();

                    if (!driverSnapshot.exists) {
                      print('Driver not found');
                      return;
                    }

                    await driverRef.update(updatedData);
                    print('Driver successfully updated');
                  } catch (e) {
                    print('Error updating driver: $e');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
