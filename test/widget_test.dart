// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:ongkir/main.dart';

void main() async {
  Uri url = Uri.parse("https://api.rajaongkir.com/starter/province?");
  final response = await http.get(
    url,
    headers: {
      "key": "97422d0ed168b91112b982b639b105ff",
    },
  );

  print(response.body);
}
