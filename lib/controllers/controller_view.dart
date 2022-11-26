import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ControllerView extends GetxController {
  var hiddenKabupatenasal = true.obs;
  var provasalId = 0.obs;
  var kotaasalId = 0.obs;
  var hiddenKabupatentujuan = true.obs;
  var provtujuanId = 0.obs;
  var kotatujuan = 0.obs;

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
