import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final box = GetStorage();
  final String baseUrl = 'http://10.0.2.2:8000/api';

  var isLoading = false.obs;
  var token = ''.obs;
  var user = {}.obs;

  @override
  void onInit() {
    super.onInit();

    //ini untuk data dari strorage
    token.value = box.read('token') ?? '';
    user.value = box.read('user') ?? {};
  }

  //ini untuk register
  Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    isLoading.value = true;

    try {
      print('Register attempt: $name, $email, $role');

      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'ContentType': 'application/json'},
            body: {
              'name': name,
              'email': email,
              'password': password,
              'role': role,
            },
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          data['message'] ?? 'Registration successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed('/login');
      } else {
        String errorMessage = data['message'] ?? 'Registration failed';

        if (data['errors'] != null) {
          final errors = data['errors'] as Map;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first;
          }
        }
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Koneksi Error : ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ini untuk login

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'ContentType': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        token.value = data['acces_token'] ?? '';
        user.value = data['user'];

        // Simpan token dan user ke GetStorage
        box.write('token', token.value);
        box.write('user', user.value);

        Get.snackbar(
          'Berhasil',
          'Login berhasil sebagai ${user['role']}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        if (isAdmin) {
          Get.offAllNamed('/admin');
        } else {
          Get.offAllNamed('/user');
        }
      } else {
        String errorMessage = data['message'] ?? 'Login gagal';

        if (data['errors'] != null) {
          final errors = data['errors'] as Map;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first;
          }
        }

        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Koneksi Error : ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ini untuk logout
  Future<void> logout() async {
    try {
      if (token.isNotEmpty) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'ContentType': 'application/json',
          },
        );
      }
    } catch (e) {
      print('Logout error: $e');
      // Handle logout error if necessary
    } finally {
      token.value = '';
      user.value = {};
      box.erase();
      Get.offAllNamed('/login');
    }
  }

  bool get isAdmin => user['role'] == 'admin';
  bool get isUser => user['role'] == 'user';
  bool get isLoggedIn => token.isNotEmpty;
  String get userName => user['name'] ?? '';
  String get userEmail => user['email'] ?? '';
  String get userRole => user['role'] ?? '';
}
