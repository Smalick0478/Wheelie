import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CNICNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Remove all non-digit characters from the text
    final digitsOnlyText = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Insert hyphens at the desired positions
    String formattedText = '';
    for (int i = 0; i < digitsOnlyText.length; i++) {
      if (i == 5 || i == 12) {
        formattedText += '-';
      }
      formattedText += digitsOnlyText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection.copyWith(
        baseOffset: formattedText.length,
        extentOffset: formattedText.length,
      ),
    );
  }
}
