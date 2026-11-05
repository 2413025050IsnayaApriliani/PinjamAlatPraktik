import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const StatCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8EDF5))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 21)),
      const SizedBox(height: 15),
      Text(value, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Color(0xFF14213D))),
      const SizedBox(height: 4),
      Text(title, style: const TextStyle(color: Color(0xFF78849A), fontSize: 12)),
    ]),
  );
}
