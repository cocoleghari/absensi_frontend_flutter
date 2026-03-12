import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';
import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/modals/tambah_pusat_lokasi.dart';

class PusatLokasiActionButton extends StatelessWidget {
  const PusatLokasiActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final PusatLokasiController controller = Get.find<PusatLokasiController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Row(
        children: [
          // Refresh Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => controller.fetchPusatLokasi(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Tambah Lokasi Button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () =>
                  TambahLokasiModal.show(context, PusatLokasiController()),
              icon: const Icon(Icons.location_on, size: 18),
              label: const Text('Tambah Lokasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
