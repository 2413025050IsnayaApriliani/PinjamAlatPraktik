import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../widgets/status_badge.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});
  String fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return Scaffold(appBar: AppBar(title: const Text('Riwayat transaksi')),
      body: AnimatedBuilder(animation: store, builder: (context, _) {
        final items = store.peminjaman.where((p) => p.status == 'Selesai' || p.status == 'Ditolak').toList();
        if (items.isEmpty) return const Center(child: Text('Belum ada riwayat transaksi.'));
        return ListView.separated(padding: const EdgeInsets.all(16), itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) { final p = items[i]; return Card(child: ListTile(
            contentPadding: const EdgeInsets.all(16), leading: Icon(p.status == 'Selesai' ? Icons.check_circle_outline : Icons.cancel_outlined, color: p.status == 'Selesai' ? const Color(0xFF16845B) : const Color(0xFFCC4242)),
            title: Text(p.namaAlat, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('${p.peminjam} • ${p.jumlah} unit\n${fmt(p.tanggalPinjam)} – ${fmt(p.tanggalKembali)}'),
            isThreeLine: true, trailing: StatusBadge(status: p.status),
          )); });
      }),
    );
  }
}
