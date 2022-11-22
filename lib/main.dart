import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ongkir/ui/cek_ongkir.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: CekOngkir.routeName,
      routes: {CekOngkir.routeName: (context) => CekOngkir()},
    );
  }
}
