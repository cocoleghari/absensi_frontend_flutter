import 'package:flutter/material.dart';
import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';

import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/widget/pusat_lokasi_empty_widget.dart';

class PusatLokasiTableWidget extends StatelessWidget {
  final PusatLokasiController pusatlokasiController;
  const PusatLokasiTableWidget({
    super.key,
    required this.pusatlokasiController,
  });
  @override
  Widget build(BuildContext context) {
    if (pusatlokasiController.pusatLokasis.isEmpty) {
      return const PusatLokasiEmptyWidget();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
            headingTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
            columnSpacing: 20,
            horizontalMargin: 16,
            columns: const [
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Nama Lokasi')),
              DataColumn(label: Text('Alamat')),
              DataColumn(label: Text('Keterangan')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: List.generate(pusatlokasiController.pusatLokasis.length, (
              index,
            ) {
              final pusat_lokasi = pusatlokasiController.pusatLokasis[index];
              return DataRow(
                cells: [
                  DataCell(
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      pusat_lokasi.nama_lokasi,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(Text(pusat_lokasi.titik_koordinat)),
                  // DataCell(_buildRoleBadge(user.role)),
                  // DataCell(
                  //   IconButton(
                  //     icon: Container(
                  //       padding: const EdgeInsets.all(4),
                  //       decoration: BoxDecoration(
                  //         color: Colors.red.shade50,
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: const Icon(
                  //         Icons.delete,
                  //         color: Colors.red,
                  //         size: 18,
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       DeletePusatLConfirmation.show(
                  //         context: context,
                  //         userName: user.name,
                  //         userId: user.id,
                  //         userController: userController,
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    final isAdmin = role == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAdmin ? Colors.purple.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAdmin ? Icons.admin_panel_settings : Icons.person,
            size: 12,
            color: isAdmin ? Colors.purple : Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            role,
            style: TextStyle(
              color: isAdmin ? Colors.purple : Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
