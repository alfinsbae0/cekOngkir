import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ongkir/data/kabupaten.dart';
import 'package:ongkir/data/provinsi.dart';
import 'package:ongkir/controllers/controller_view.dart';

class CekOngkir extends StatelessWidget {
  var controller = Get.put(ControllerView());
  static const routeName = '/cekongkir';
  CekOngkir({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Text("Cek Ongkir Indonesia"),
          ],
        ),
      ),
      body: ListView(
        children: [
          Provinsi(tipe: "asal"),
          Obx(
            () => controller.hiddenKabupatenasal.isTrue
                ? SizedBox()
                : Kota(
                    provId: controller.provasalId.value,
                    tipe: 'asal',
                  ),
          ),
          Provinsi(tipe: "tujuan"),
          Obx(
            () => controller.hiddenKabupatentujuan.isTrue
                ? SizedBox()
                : Kota(
                    provId: controller.provtujuanId.value,
                    tipe: 'tujuan',
                  ),
          ),
          Berat(),
          Kurir(),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => controller.hiddenButton.isTrue
                ? SizedBox(
                    height: 10,
                  )
                : Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        onPressed: () => controller.cekongkir(),
                        child: Text("Cek Ongkir"),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white)),
                  ),
          ),
        ],
      ),
    );
  }
}

class Provinsi extends GetView<ControllerView> {
  const Provinsi({
    Key? key,
    required this.tipe,
  }) : super(key: key);

  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownSearch<Province>(
        clearButtonProps: ClearButtonProps(isVisible: true),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: tipe == "asal" ? "Provinsi Asal" : "Provinsi Tujuan",
            border: OutlineInputBorder(),
          ),
        ),
        asyncItems: (String filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/province?");
          try {
            final response = await http.get(
              url,
              headers: {
                "key": "97422d0ed168b91112b982b639b105ff",
              },
            );

            Map<String, dynamic> data =
                Map<String, dynamic>.from(json.decode(response.body));
            // var data = json.decode(response.body) as new Map<String, dynamic>;
            var statusCode = data["rajaongkir"]["status"]["code"];
            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }
            // var listAllProvince = data["rajaongkir"] ?? ["result"] as List;
            List<dynamic> listAllProvince =
                ((data["rajaongkir"]["results"]) as List);

            var models = Province.fromJsonList(listAllProvince);
            return models;
          } catch (err) {
            print(err);
            return List<Province>.empty();
          }
        },
        onChanged: (prov) {
          if (prov != null) {
            if (tipe == "asal") {
              controller.hiddenKabupatenasal.value = false;
              controller.provasalId.value = int.parse(prov.provinceId!);
            } else {
              controller.hiddenKabupatentujuan.value = false;
              controller.provtujuanId.value = int.parse(prov.provinceId!);
              ;
            }
          } else {
            if (tipe == "asal") {
              controller.hiddenKabupatenasal.value = true;
              controller.provasalId.value = 0;
            } else {
              controller.hiddenKabupatentujuan.value = true;
              controller.provtujuanId.value = 0;
            }
          }
        },
        popupProps: PopupProps.menu(
          itemBuilder: (context, item, isSelected) {
            return Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  "${item.province}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          },
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: "Search Province"),
          ),
        ),
        itemAsString: (item) => item.province!,
      ),
    );
  }
}

class Kota extends GetView<ControllerView> {
  const Kota({
    Key? key,
    required this.provId,
    required this.tipe,
  }) : super(key: key);

  final int provId;
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownSearch<Kabupaten>(
        clearButtonProps: ClearButtonProps(isVisible: true),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: tipe == "asal"
                ? "Kabupaten / Kota Asal"
                : "Kabupaten / Kota Tujuan",
            border: OutlineInputBorder(),
          ),
        ),
        asyncItems: (String filter) async {
          Uri url = Uri.parse(
              "https://api.rajaongkir.com/starter/city?province=$provId");
          try {
            final response = await http.get(
              url,
              headers: {
                "key": "97422d0ed168b91112b982b639b105ff",
              },
            );

            Map<String, dynamic> data =
                Map<String, dynamic>.from(json.decode(response.body));
            // var data = json.decode(response.body) as new Map<String, dynamic>;
            var statusCode = data["rajaongkir"]["status"]["code"];
            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }
            // var listAllProvince = data["rajaongkir"] ?? ["result"] as List;
            List<dynamic> listAllKabupaten =
                ((data["rajaongkir"]["results"]) as List);

            var models = Kabupaten.fromJsonList(listAllKabupaten);
            return models;
          } catch (err) {
            print(err);
            return List<Kabupaten>.empty();
          }
        },
        onChanged: (cityvalue) {
          if (cityvalue != null) {
            if (tipe == "asal") {
              controller.kotaasalId.value = int.parse(cityvalue.cityId!);
            } else {
              controller.kotatujuan.value = int.parse(cityvalue.cityId!);
            }
          } else {
            if (tipe == "asal") {
              print("Tidak ada");
              controller.kotaasalId.value = 0;
            } else {
              print("tidak ada");
              controller.kotatujuan.value = 0;
            }
          }
        },
        popupProps: PopupProps.menu(
          itemBuilder: (context, item, isSelected) {
            return Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  "${item.type} " "${item.cityName}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          },
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: "Search Kabupaten / Kota"),
          ),
        ),
        itemAsString: (item) => "${item.type} ${item.cityName}",
      ),
    );
  }
}

class Berat extends GetView<ControllerView> {
  const Berat({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: false,
              controller: controller.beratC,
              decoration: InputDecoration(
                labelText: "Berat Barang",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) => controller.ubahBerat(value),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 130,
            child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                // showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              items: ["kg", "gr", "ons"],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    labelText: "Satuan Berat", border: OutlineInputBorder()),
              ),
              selectedItem: "gram",
              onChanged: (value) => controller.ubahSatuan(value!),
            ),
          )
        ],
      ),
    );
  }
}

class Kurir extends GetView<ControllerView> {
  const Kurir({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: DropdownSearch<Map<String, dynamic>>(
          clearButtonProps: ClearButtonProps(isVisible: true),
          items: [
            {"code": "jne", "name": "JNE"},
            {"code": "tiki", "name": "TIKI"},
            {"code": "pos", "name": "POS"},
          ],
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Kurir",
            ),
          ),
          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) => Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "${item['name']}",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              controller.listKurir.value = value["code"];
              controller.hiddenButton.value = false;
            } else {
              controller.hiddenButton.value = true;
              controller.listKurir.value = "";
            }
          },
          itemAsString: (item) => "${item["name"]}",
        ),
      ),
    );
  }
}
