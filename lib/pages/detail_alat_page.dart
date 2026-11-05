import 'package:flutter/material.dart';
import '../models/alat.dart';
import 'pengajuan_peminjaman_page.dart';

class DetailAlatPage extends StatelessWidget {
  final Alat alat;
  const DetailAlatPage({super.key, required this.alat});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detail peralatan')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(height: 180, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE9EEFF), Color(0xFFF7F9FF)]), borderRadius: BorderRadius.circular(24)),
        child: const Icon(Icons.inventory_2_rounded, color: Color(0xFF3867F4), size: 76)),
      const SizedBox(height: 22),
      Text(alat.nama, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Color(0xFF14213D))),
      const SizedBox(height: 6), Text('Kode inventaris: ${alat.kode}', style: const TextStyle(color: Color(0xFF78849A))),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: _info('Jumlah total', '${alat.jumlah}', Icons.inventory_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _info('Tersedia', '${alat.tersedia}', Icons.check_circle_outline)),
      ]),
      const SizedBox(height: 12),
      _info('Kondisi alat', alat.kondisi, Icons.health_and_safety_outlined),
      const SizedBox(height: 20),
      const Text('Deskripsi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8), Text(alat.deskripsi, style: const TextStyle(height: 1.6, color: Color(0xFF596579))),
      const SizedBox(height: 26),
      if (alat.tersedia > 0) SizedBox(width: double.infinity, child: ElevatedButton.icon(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PengajuanPeminjamanPage(alat: alat))),
        icon: const Icon(Icons.assignment_add), label: const Text('Ajukan peminjaman'))),
    ]),
  );

  Widget _info(String title, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE8EDF5))),
    child: Row(children: [Icon(icon, color: const Color(0xFF3867F4)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF78849A))), const SizedBox(height: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
    ]))]),
  );
}
