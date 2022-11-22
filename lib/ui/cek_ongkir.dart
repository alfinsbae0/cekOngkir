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
            Image.network(
              "https://cektarif.com/images/logo-cektarif.png",
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 5,
            ),
            Text("Cek Ongkir Indonesia"),
          ],
        ),
      ),
      body: ListView(
        children: [
          Provinsi(),
          Obx(
            () => controller.hiddenKabupaten.isTrue
                ? SizedBox()
                : Kota(
                    provId: controller.provId.value,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownSearch<Province>(
        clearButtonProps: ClearButtonProps(isVisible: true),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Provinsi Asal",
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
            controller.hiddenKabupaten.value = false;
            controller.provId.value = int.parse(prov.provinceId!);
          } else {
            controller.hiddenKabupaten.value = true;
            controller.provId.value = 0;
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
  const Kota({Key? key, required this.provId}) : super(key: key);

  final int provId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownSearch<Kabupaten>(
        clearButtonProps: ClearButtonProps(isVisible: true),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Kabupaten / Kota Asal",
            border: OutlineInputBorder(),
          ),
        ),
        asyncItems: (String filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/city?");
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
        onChanged: (value) {
          if (value != null) {
            print(value.cityName);
          } else {
            print("Tidak ada");
          }
        },
        popupProps: PopupProps.menu(
          itemBuilder: (context, item, isSelected) {
            return Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  "${item.cityName}" "${item.type}",
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
        itemAsString: (item) => "${item.cityName} ${item.type}",
      ),
    );
  }
}
