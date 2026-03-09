import 'package:flutter/material.dart';
import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/modals/tambah_pusat_lokasi.dart';

class PusatLokasiActionButton extends StatelessWidget {
  final PusatLokasiController pusatLokasiController;
  const PusatLokasiActionButton({
    super.key,
    required this.pusatLokasiController,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: pusatLokasiController.fetchUsers,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              side: BorderSide(color: Colors.blue.shade200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () =>
                TambahLokasiModal.show(context, pusatLokasiController),
            icon: const Icon(Icons.person_add),
            label: const Text('Tambah Lokasi'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
            ),
          ),
        ),
      ],
    );
  }
}
