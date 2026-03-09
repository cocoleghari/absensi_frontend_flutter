import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';

class TambahLokasiModal {
  static void show(
    BuildContext context,
    PusatLokasiController pusatController,
  ) {
    final nama_lokasiC = TextEditingController();
    final titik_koordinatC = TextEditingController();
    final keterangan_lokasiC = TextEditingController();
    const String role = 'user';
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFormFields(
                nama_lokasiC,
                titik_koordinatC,
                keterangan_lokasiC,
              ),
              const SizedBox(height: 24),
              _buildRegisterButton(
                nama_lokasiC,
                titik_koordinatC,
                keterangan_lokasiC,
                pusatController,
              ),
              const SizedBox(height: 12),
              _buildCancelButton(),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  static Widget _buildHandle() {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_add, color: Colors.blue, size: 24),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Lokasi Baru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Isi data dengan lengkap',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildFormFields(
    TextEditingController nama_lokasiC,
    TextEditingController alamat_lokasiC,
    TextEditingController keterangan_lokasiC,
  ) {
    return Column(
      children: [
        TextField(
          controller: nama_lokasiC,
          decoration: InputDecoration(
            labelText: 'Nama Lokasi',
            hintText: 'Masukkan nama lokasi',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: alamat_lokasiC,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Titik Koordinat',
            hintText: 'Masukan',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            prefixIcon: const Icon(
              Icons.location_on_rounded,
              color: Colors.blue,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: keterangan_lokasiC,
          // maxLines: 2,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Keterangan Lokasi',
            hintText: 'Masukkan Keterangan Lokasi',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            prefixIcon: const Icon(Icons.note, color: Colors.blue),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  static Widget _buildRegisterButton(
    TextEditingController nama_lokasiC,
    TextEditingController alamat_lokasiC,
    TextEditingController keterangan_lokasiC,
    PusatLokasiController pusatController,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _validateAndRegister(
          nama_lokasiC,
          alamat_lokasiC,
          keterangan_lokasiC,
          pusatController,
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
        ),
        child: const Text(
          'TAMBAHKAN LOKASI',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
      ),
    );
  }

  static void _validateAndRegister(
    TextEditingController nama_lokasiC,
    TextEditingController alamat_lokasiC,
    TextEditingController keterangan_lokasiC,
    PusatLokasiController pusatController,
  ) {
    // Validasi
    if (nama_lokasiC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama wajib diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (alamat_lokasiC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email wajib diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (keterangan_lokasiC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email wajib diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Tutup bottom sheet
    Get.back();
    // Tampilkan dialog konfirmasi
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Konfirmasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Daftarkan akun sebagai USER?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              pusatController.tambahLokasi(
                nama_lokasi: nama_lokasiC.text,
                alamat_lokasi: alamat_lokasiC.text,
                keterangan_lokasi: keterangan_lokasiC.text,
                role: 'user',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Ya, Daftar'),
          ),
        ],
      ),
    );
  }
}
