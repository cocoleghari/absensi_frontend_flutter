import 'package:absensi_frontend_flutter/controllers/user_lokasi_controller.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLokasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserLokasiController>(
      () => UserLokasiController(),
      fenix: true,
    );
  }
}
