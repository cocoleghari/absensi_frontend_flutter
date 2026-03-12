import 'package:absensi_frontend_flutter/pages/admin/pusat_lokasi/modals/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';

class TambahLokasiModal {
  static void show(
    BuildContext context,
    PusatLokasiController pusatController,
  ) {
    final namaLokasiC = TextEditingController();
    final titikKordinatC = TextEditingController();
    final alamatLengkapC = TextEditingController();
    final keteranganC = TextEditingController();

    Get.bottomSheet(
      _TambahLokasiSheet(
        namaLokasiC: namaLokasiC,
        titikKordinatC: titikKordinatC,
        alamatLengkapC: alamatLengkapC,
        keteranganC: keteranganC,
        pusatController: pusatController,
      ),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }
}

// ─── StatefulWidget agar bisa setState saat koordinat diisi dari map ──────────
class _TambahLokasiSheet extends StatefulWidget {
  final TextEditingController namaLokasiC;
  final TextEditingController titikKordinatC;
  final TextEditingController alamatLengkapC;
  final TextEditingController keteranganC;
  final PusatLokasiController pusatController;

  const _TambahLokasiSheet({
    required this.namaLokasiC,
    required this.titikKordinatC,
    required this.alamatLengkapC,
    required this.keteranganC,
    required this.pusatController,
  });

  @override
  State<_TambahLokasiSheet> createState() => _TambahLokasiSheetState();
}

class _TambahLokasiSheetState extends State<_TambahLokasiSheet> {
  Future<void> _openMapPicker() async {
    // Navigasi ke MapPickerPage, hasil berupa String koordinat "lat, lng"
    final String? result = await Get.to<String>(
      () => const MapPickerPage(),
      fullscreenDialog: true,
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        widget.titikKordinatC.text = result;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.blue, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  void _validateAndSave() {
    if (widget.namaLokasiC.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Nama lokasi wajib diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (widget.titikKordinatC.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Titik kordinat wajib diisi. Tap ikon map untuk memilih lokasi.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    Get.back();

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Konfirmasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Simpan data pusat lokasi ini?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              widget.pusatController.createPusatLokasi(
                nama_lokasi: widget.namaLokasiC.text.trim(),
                titik_koordinat: widget.titikKordinatC.text.trim(),
                keterangan_lokasi: widget.keteranganC.text.trim().isNotEmpty
                    ? widget.keteranganC.text.trim()
                    : null,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Center(
              child: Text(
                'Tambah Pusat Lokasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nama Lokasi
            _buildTextField(
              controller: widget.namaLokasiC,
              hint: 'Nama Lokasi *',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 12),

            // Titik Kordinat + Tombol Map
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: widget.titikKordinatC,
                    hint: 'Titik Kordinat *',
                    icon: Icons.location_on,
                    readOnly: true, // diisi otomatis dari map picker
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _openMapPicker,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Alamat Lengkap
            _buildTextField(
              controller: widget.alamatLengkapC,
              hint: 'Alamat Lengkap',
              icon: Icons.apartment,
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            // Keterangan (Opsional)
            _buildTextField(
              controller: widget.keteranganC,
              hint: 'Keterangan (Opsional)',
              icon: Icons.description_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 28),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _validateAndSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
