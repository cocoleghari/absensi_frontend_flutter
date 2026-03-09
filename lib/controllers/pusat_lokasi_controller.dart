import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/pusat_lokasi_model.dart';
import 'auth_controller.dart';

class PusatLokasiController extends GetxController {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  var users = <PusatLokasiModel>[].obs;
  var isLoading = false.obs;

  final AuthController authController = Get.find<AuthController>();

  Map<String, String> get _authHeaders => {
    'Accept': 'application/json',
    'Authorization':
        'Bearer ${authController.token.value}', // Pastikan token diambil dari AuthController
  };

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      if (authController.token.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Anda harus login sebagai admin.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final res = await http.get(
        Uri.parse('$baseUrl/admin/users'),
        headers: _authHeaders,
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        users.value = (json['data'] as List)
            .map((e) => PusatLokasiModel.fromJson(e))
            .toList();
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        Get.snackbar(
          'Sesi habis',
          'Silahkan login kembai.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // register user
  Future<void> tambahLokasi({
    required String nama_lokasi,
    required String alamat_lokasi,
    required String keterangan_lokasi,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      if (authController.token.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Anda harus login sebagai admin.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _authHeaders..addAll({'Content-Type': 'application/json'}),
        body: jsonEncode({
          'nama_lokasi': nama_lokasi,
          'alamat_lokasi': alamat_lokasi,
          'keterangan_lokasi': keterangan_lokasi,
          'role': role,
        }),
      );

      if (res.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'User berhasil didaftarkan.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchUsers(); // Refresh daftar pengguna setelah registrasi
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        Get.snackbar(
          'Sesi habis',
          'Silahkan login kembai.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        final json = jsonDecode(res.body);
        Get.snackbar(
          'Error',
          json['message'] ?? 'Gagal mendaftarkan user.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete user
  Future<void> deleteLokasi(int userId) async {
    try {
      isLoading.value = true;

      if (authController.token.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Anda harus login sebagai admin.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final res = await http.delete(
        Uri.parse('$baseUrl/admin/users/$userId'),
        headers: _authHeaders,
      );

      if (res.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          'User berhasil dihapus.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchUsers(); // Refresh daftar pengguna setelah penghapusan
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        Get.snackbar(
          'Sesi habis',
          'Silahkan login kembai.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        final json = jsonDecode(res.body);
        Get.snackbar(
          'Error',
          json['message'] ?? 'Gagal menghapus user.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
