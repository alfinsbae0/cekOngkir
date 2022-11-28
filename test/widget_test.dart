// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
  final response = await http.post(
    url,
    body: {
      "origin": "502",
      "destination": "114",
      "weight": "1700",
      "courier": "jne"
    },
    headers: {
      "content-type": "application/x-www-form-urlencoded",
      "key": "97422d0ed168b91112b982b639b105ff",
    },
  );

  print(response.body);
}
