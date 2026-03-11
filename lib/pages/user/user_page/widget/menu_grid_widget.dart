import 'package:flutter/material.dart';

class MenuGridWidget extends StatelessWidget {
  final VoidCallback? onMasuk;
  final VoidCallback? onPulang;
  final bool isPulangEnabled;

  const MenuGridWidget({
    super.key,
    this.onMasuk,
    this.onPulang,
    this.isPulangEnabled = false,
  });

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
          const Text(
            'Menu Absen',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Tombol Masuk
              Expanded(
                child: _MenuCard(
                  icon: Icons.login_rounded,
                  label: 'Masuk',
                  isEnabled: true,
                  iconColor: const Color(0xFF2196F3),
                  iconBgColor: const Color(0xFFE3F2FD),
                  onTap: onMasuk,
                ),
              ),
              const SizedBox(width: 12),
              // Tombol Pulang
              Expanded(
                child: _MenuCard(
                  icon: Icons.logout_rounded,
                  label: 'Pulang',
                  isEnabled: isPulangEnabled,
                  iconColor: Colors.grey.shade500,
                  iconBgColor: Colors.grey.shade100,
                  onTap: isPulangEnabled ? onPulang : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEnabled;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.isEnabled,
    required this.iconColor,
    required this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? Colors.grey.shade200 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isEnabled ? Colors.black87 : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
