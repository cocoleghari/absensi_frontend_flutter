import 'package:flutter/material.dart';

class InfoCardWidget extends StatelessWidget {
  final String message;

  const InfoCardWidget({
    super.key,
    this.message =
        'Sistem otomatis mendeteksi lokasi terdekat. GPS aktif dan radius 100m. Foto wajah sebagai bukti.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: Color(0xFF1976D2),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF1565C0),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
