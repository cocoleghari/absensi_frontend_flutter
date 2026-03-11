import 'package:flutter/material.dart';

class StatusCardWidget extends StatelessWidget {
  final String? jamMasuk;
  final String? jamPulang;

  const StatusCardWidget({super.key, this.jamMasuk, this.jamPulang});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status Hari Ini',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh, size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              children: [
                // Status Masuk
                Expanded(
                  child: _StatusItem(
                    icon: Icons.login_rounded,
                    label: 'Masuk',
                    time: jamMasuk ?? '--:--',
                  ),
                ),
                // Divider vertikal
                Container(
                  width: 1,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                // Status Pulang
                Expanded(
                  child: _StatusItem(
                    icon: Icons.logout_rounded,
                    label: 'Pulang',
                    time: jamPulang ?? '--:--',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: Icon(icon, size: 22, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 2),
        Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }
}
