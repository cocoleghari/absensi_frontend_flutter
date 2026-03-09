import 'package:absensi_frontend_flutter/controllers/auth_controller.dart';
import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';
import 'package:absensi_frontend_flutter/pages/admin/master_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_action_button.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_empty_widget.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_header_widget.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_info_card.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_table_widget.dart';

class ListPusatLokasi extends GetView<PusatLokasiController> {
  const ListPusatLokasi({super.key});
  @override
  Widget build(BuildContext context) {
    final PusatLokasiController Controller = Get.find<PusatLokasiController>();
    final AuthController Controller2 = Get.find<AuthController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Controller.fetchUsers();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Lokasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: 'Konfirmasi Logout',
                middleText: 'Yakin ingin logout?',
                textCancel: 'Batal',
                textConfirm: 'Logout',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back();
                  Controller2.logout();
                },
              );
            },
          ),
        ],
      ),
      drawer: const MasterDrawer(currentPage: 'admin'),
      body: Obx(() {
        if (Controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat data...'),
              ],
            ),
          );
        }
        // final int totalUsers = Controller.users.length;
        // final int totalAdmins = Controller.users
        //     .where((u) => u.role == 'admin')
        //     .length;
        // final int totalRegularUsers = Controller.users
        //     .where((u) => u.role == 'user')
        //     .length;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header dengan statistik
                // AkunHeaderWidget(
                //   totalUsers: totalUsers,
                //   totalAdmins: totalAdmins,
                //   totalRegularUsers: totalRegularUsers,
                // ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: PusatLokasiTableWidget(
                      pusatlokasiController: PusatLokasiController(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      PusatLokasiActionButton(
                        pusatLokasiController: PusatLokasiController(),
                      ),
                      const SizedBox(height: 10),
                      const PusatLokasiInfoCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
