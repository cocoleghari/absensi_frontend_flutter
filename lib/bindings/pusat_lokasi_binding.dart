import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';
import 'package:get/get.dart';

class PusatLokasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PusatLokasiController>(
      () => PusatLokasiController(),
      fenix: true,
    );
  }
}
