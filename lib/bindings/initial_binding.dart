import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';
import 'package:absensi_frontend_flutter/controllers/user_lokasi_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<UserLokasiController>(UserLokasiController(), permanent: true);
    Get.put<PusatLokasiController>(PusatLokasiController(), permanent: true);
  }
}
