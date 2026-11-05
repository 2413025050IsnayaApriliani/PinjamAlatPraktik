import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = switch (status) {
      'Disetujui' => const Color(0xFF16845B),
      'Dipinjam' => const Color(0xFF3867F4),
      'Selesai' => const Color(0xFF16845B),
      'Ditolak' => const Color(0xFFCC4242),
      _ => const Color(0xFFB7791F),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: .10), borderRadius: BorderRadius.circular(30)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}
