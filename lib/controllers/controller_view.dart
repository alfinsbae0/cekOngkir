import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ongkir/data/courier.dart';

class ControllerView extends GetxController {
  var hiddenKabupatenasal = true.obs;
  var provasalId = 0.obs;
  var kotaasalId = 0.obs;
  var hiddenKabupatentujuan = true.obs;
  var provtujuanId = 0.obs;
  var kotatujuan = 0.obs;
  var hiddenButton = true.obs;
  var listKurir = "".obs;

  double berat = 0.0;
  String satuan = "gram";

  late TextEditingController beratC;

  void cekongkir() async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
    try {
      final response = await http.post(
        url,
        body: {
          "origin": "$kotaasalId",
          "destination": "$kotatujuan",
          "weight": "$berat",
          "courier": "$listKurir"
        },
        headers: {
          "content-type": "application/x-www-form-urlencoded",
          "key": "97422d0ed168b91112b982b639b105ff",
        },
      );
      print(response.toString());

      var data = json.decode(response.body) as Map<String, dynamic>;
      var results = data["rajaongkir"]["results"] as List<dynamic>;
      var allCourier = Courier.fromJsonList(results);
      var courier = allCourier[0];
      print("berhasil");

      Get.defaultDialog(
        title: courier.name!,
        textCancel: "Kembali",
        barrierDismissible: false,
        content: Column(
          children: courier.costs!
              .map((e) => ListTile(
                    title: Text("${e.service}"),
                    subtitle: Text("Rp. ${e.cost![0].value}"),
                    trailing: Text(courier.code == "pos"
                        ? "${e.cost![0].etd}"
                        : "${e.cost![0].etd} HARI"),
                  ))
              .toList(),
        ),
      );
    } catch (err) {
      Get.defaultDialog(title: "Terjadi Kesalahan").toString();
    }
  }

  void ubahBerat(String value) {
    berat = double.tryParse(value) ?? 0.0;
    String cekSatuan = satuan;
    switch (cekSatuan) {
      case "kg":
        berat = berat * 1000;
        break;
      case "gram":
        berat = berat;
        break;
      case "ons":
        berat = berat * 100;
        break;
      default:
        berat = berat;
    }
    print("$berat gram");
  }

  void ubahSatuan(String value) {
    berat = double.tryParse(beratC.text) ?? 0.0;
    switch (value) {
      case "kg":
        berat = berat * 1000;
        break;
      case "gram":
        berat = berat;
        break;
      case "ons":
        berat = berat * 100;
        break;
      default:
        berat = berat;
    }
    satuan = value;
    print("$berat gram");
  }

  @override
  void onInit() {
    beratC = TextEditingController(text: "$berat");
    super.onInit();
  }

  @override
  void onClose() {
    beratC.dispose();
    super.onClose();
  }
}
