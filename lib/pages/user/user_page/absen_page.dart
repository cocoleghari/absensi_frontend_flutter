import 'package:flutter/material.dart';
import 'package:absensi_frontend_flutter/pages/user/user_page/widget/user_header_widget.dart';
import 'package:absensi_frontend_flutter/pages/user/user_page/widget/status_card_widget.dart';
import 'package:absensi_frontend_flutter/pages/user/user_page/widget/menu_grid_widget.dart';
import 'package:absensi_frontend_flutter/pages/user/user_page/widget/info_card_widget.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({super.key});

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  String? _jamMasuk;
  String? _jamPulang;
  bool _sudahMasuk = false;

  void _handleMasuk() {
    final now = TimeOfDay.now();
    setState(() {
      _jamMasuk =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _sudahMasuk = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Absen masuk berhasil!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handlePulang() {
    final now = TimeOfDay.now();
    setState(() {
      _jamPulang =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Absen pulang berhasil!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          // ── Header biru dengan gradient ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Widget 1: User Header
                  const UserHeaderWidget(),
                  const SizedBox(height: 8),

                  // Widget 2: Status Card (overlap ke luar header)
                  Transform.translate(
                    offset: const Offset(0, 20),
                    child: StatusCardWidget(
                      jamMasuk: _jamMasuk,
                      jamPulang: _jamPulang,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Konten bawah ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Widget 3: Menu Grid
                  MenuGridWidget(
                    onMasuk: _handleMasuk,
                    onPulang: _handlePulang,
                    isPulangEnabled: _sudahMasuk,
                  ),

                  const SizedBox(height: 16),

                  // Widget 4: Info Card
                  const InfoCardWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
