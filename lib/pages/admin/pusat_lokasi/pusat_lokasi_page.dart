import 'package:absensi_frontend_flutter/controllers/auth_controller.dart';
import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';
import 'package:absensi_frontend_flutter/pages/admin/master_drawer.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_action_button.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_header_widget.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_search_widget.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListPusatLokasi extends GetView<PusatLokasiController> {
  const ListPusatLokasi({super.key});

  @override
  Widget build(BuildContext context) {
    final PusatLokasiController pusatLokasiController =
        Get.find<PusatLokasiController>();
    final AuthController authController = Get.find<AuthController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pusatLokasiController.fetchPusatLokasi();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan Pusat Lokasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => pusatLokasiController.fetchPusatLokasi(),
          ),
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
                  authController.logout();
                },
              );
            },
          ),
        ],
      ),
      drawer: const MasterDrawer(currentPage: 'admin'),
      body: Obx(() {
        if (pusatLokasiController.isLoading.value) {
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
                // 1. Header Widget
                const PusatLokasiHeaderWidget(),

                // 2. Search Widget
                const PusatLokasiSearchWidget(),

                // 3. Table Widget (Expanded agar mengisi sisa ruang)
                const Expanded(child: PusatLokasiTableWidget()),

                // 4. Action Button (Refresh & Tambah Lokasi)
                const PusatLokasiActionButton(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
