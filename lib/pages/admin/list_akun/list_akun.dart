import 'package:absensi_frontend_flutter/controllers/auth_controller.dart';
import 'package:absensi_frontend_flutter/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class ListAkun extends GetView {
//   const ListAkun({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'List Akun',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               Get.defaultDialog(
//                 title: 'Konfirmasi Logout',
//                 middleText: 'Apakah Anda yakin ingin logout?',
//                 textCancel: 'Batal',
//                 textConfirm: 'Logout',
//                 confirmTextColor: Colors.white,
//                 buttonColor: Colors.red,
//                 onConfirm: () {
//                   Get.back();
//                   controller.logout();
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class ListAkun extends GetView<AuthController> {
  const ListAkun({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.fetchUsers();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Akun',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                middleText: 'Apakah Anda yakin ingin logout?',
                textCancel: 'Batal',
                textConfirm: 'Logout',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back();
                  Get.find<AuthController>().logout();
                },
              );
            },
          ),
        ],
      ),
      drawer: const MasterDrawer(currentPage: 'admin'),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat data pengguna...'),
              ],
            ),
          );
        }

        // hitung jumlah admin dan user
        final int totalUsers = userController.users.length;
        final int totalAdmins = userController.users
            .where((u) => u.role == 'admin')
            .length;
        final int totalRegularUsers = userController.users
            .where((u) => u.role == 'user')
            .length;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.withOpacity(0.1), Colors.white],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header dengan statistik
                AkunHeaderWidget(
                  totalUsers: totalUsers,
                  totalAdmins: totalAdmins,
                  totalRegularUsers: totalRegularUsers,
                ),

                // Tabel data user
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: AkunTableWidget(userController: userController),
                  ),
                ),

                // Tombol  dan info card
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      AkunActionButtons(userController: userController),
                      const SizedBox(height: 16),
                      const AkunInfoCard(),
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
