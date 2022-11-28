import 'package:flutter/material.dart';
import 'package:ongkir/ui/cek_ongkir.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: CekOngkir.routeName,
      routes: {CekOngkir.routeName: (context) => CekOngkir()},
    );
  }
}
