import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ControllerView extends GetxController {
  var hiddenKabupaten = true.obs;
  var provId = 0.obs;

  Future<void> init() async {
    Get.put(ControllerView());
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
