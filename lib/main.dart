import 'package:absensi_frontend_flutter/bindings/lokasi_binding.dart';
import 'package:absensi_frontend_flutter/pages/admin/lokasi_page/lokasi_page.dart';
import 'package:absensi_frontend_flutter/pages/user/user_page/user_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/initial_binding.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/admin/list_akun/list_akun.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Absensi Admin',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: _getInitialRoute(),
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        // ini routing untuk admin
        GetPage(name: '/admin', page: () => const ListAkunPage()),
        GetPage(
          name: '/admin/lokasi',
          page: () => const LokasiPage(),
          binding: LokasiBinding(),
        ),
        GetPage(
          name: '/users',
          page: () => const UserPage(),
          binding: LokasiBinding(),
        ),
      ],
    );
  }

  String _getInitialRoute() {
    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();

      if (auth.isLoggedIn) {
        if (auth.isAdmin) {
          return '/admin';
        } else {
          // Tambahkan route untuk user biasa jika diperlukan
          return '/user';
        }
      }
    }

    return '/login';
  }
}
