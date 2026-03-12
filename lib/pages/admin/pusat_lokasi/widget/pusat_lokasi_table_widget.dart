import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_frontend_flutter/controllers/pusat_lokasi_controller.dart';

class PusatLokasiTableWidget extends StatelessWidget {
  const PusatLokasiTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PusatLokasiController controller = Get.find<PusatLokasiController>();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Table Header
            Container(
              color: Colors.blue.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Obx(
                      () => Checkbox(
                        value:
                            controller.filteredLokasis.isNotEmpty &&
                            controller.selectedIds.length ==
                                controller.filteredLokasis.length,
                        onChanged: (_) => controller.selectAll(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const SizedBox(
                    width: 36,
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Nama Lokasi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Titik Kordinat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 52,
                    child: Text(
                      'Aksi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Table Body
            Expanded(
              child: Obx(() {
                final filtered = controller.filteredLokasis;

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada lokasi terdaftar',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: filtered.length,
                  separatorBuilder: (_, _x) =>
                      Divider(height: 1, color: Colors.blue.shade50),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final bool isSelected = controller.selectedIds.contains(
                      item.id,
                    );

                    return InkWell(
                      onTap: () {
                        if (controller.isSelectionMode.value) {
                          controller.toggleSelectItem(item.id);
                        }
                      },
                      onLongPress: () {
                        controller.isSelectionMode.value = true;
                        controller.toggleSelectItem(item.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Obx(
                                () => Checkbox(
                                  value: controller.selectedIds.contains(
                                    item.id,
                                  ),
                                  onChanged: (_) =>
                                      controller.toggleSelectItem(item.id),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 36,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                item.nama_lokasi,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.titik_koordinat ?? '-',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Kolom Aksi - tombol hapus
                            SizedBox(
                              width: 52,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () =>
                                      _confirmDelete(context, controller, item),
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    PusatLokasiController controller,
    dynamic item,
  ) {
    Get.defaultDialog(
      title: 'Hapus Lokasi',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Yakin ingin menghapus\n"${item.nama_lokasi}"?',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            'Data yang dihapus tidak dapat dikembalikan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.blue,
      onConfirm: () async {
        Get.back(); // tutup dialog konfirmasi

        // Tampilkan loading
        // Get.dialog(
        //   const Center(
        //     child: Card(
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(16)),
        //       ),
        //       child: Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             CircularProgressIndicator(),
        //             SizedBox(height: 16),
        //             Text('Menghapus data...'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        //   barrierDismissible: false,
        // );

        // Panggil method dari controller, tunggu hasil bool
        final bool success = await controller.deletePusatLokasi(item.id);

        // Tutup loading
        if (Get.isDialogOpen ?? false) Get.back();

        // Snackbar sudah ditangani di dalam controller,
        // tapi kita bisa tambahkan aksi tambahan jika perlu
        if (!success) {
          // Jika gagal, tidak perlu aksi tambahan karena
          // controller sudah menampilkan snackbar error
        }
      },
    );
  }
}
