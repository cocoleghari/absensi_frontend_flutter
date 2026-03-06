import 'dart:convert';
import 'dart:io';

import 'package:absensi_frontend_flutter/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class UserLokasiController extends GetxController {
  final auth = Get.find<AuthController>();

  final String baseUrl = 'http://10.0.2.2:8000/api';

  var userLokasis = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isSubmit = false.obs;
  var errorMessage = ''.obs;
  // untuk riwayat absensi
  var riwayatAbsensi = <Map<String, dynamic>>[].obs;
  var loadingRiwataAbsensi = false.obs;
  // untuk absen
  var isMasuk = false.obs;
  var isPulang = false.obs;
  var absenMasuk = Rxn<Map<String, dynamic>>();
  var absenPulang = Rxn<Map<String, dynamic>>();

  // lokasi realtime pengguna
  var simpanLokasi = ''.obs;
  var prosesLokasi = false.obs;

  // pengambilan foto wajah
  var fotoWajah = Rxn<File>();
  var ambilFoto = false.obs;
  var deteksiWajah = false.obs;

  var simpanLokasiMap = Rxn<Map<String, dynamic>>();
  var jarakTerdekat = 0.0.obs;
  var jangkauanLokasi = false.obs;

  @override
  void onInit() {
    super.onInit();

    print('Inisialisasi Controller');

    cekStatusHariIni();
  }

  Future<void> cekStatusHariIni() async {
    try {
      print('cek status hari ini');

      if (auth.token.isEmpty) {
        print('token kosong');
      }

      final Response = await http
          .get(
            Uri.parse('$baseUrl/user/absensi/cek-status'),
            headers: {
              'Accept': 'aplication/json',
              'Authorization': 'Bearier ${auth.token} ',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (Response.statusCode == 200) {
        final data = jsonDecode(Response.body);

        isMasuk.value = data['sudah_masuk'] ?? false;
        isPulang.value = data['sudah_pulang'] ?? false;
        absenMasuk.value = data['data_masuk'];
        absenPulang.value = data['data_pulang'];

        print('status absen masuk = $isMasuk, pulang = $isPulang');
      }
    } catch (e) {
      print('error cek status : $e');
    }
  }
}
