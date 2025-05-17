import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

logX(dynamic data, [String? tag]) {
  final String tagData = tag != null ? tag.toString() : '';
  debugPrint("$tagData : $data");
}

class EmojiFilteringTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredText = newValue.text.replaceAll(RegExp(r'[\u{1F600}-\u{1F64F}]', unicode: true), '');
    return newValue.copyWith(text: filteredText);
  }
}
