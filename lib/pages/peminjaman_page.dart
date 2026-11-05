import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../widgets/status_badge.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});
  String fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return Scaffold(appBar: AppBar(title: const Text('Peminjaman saya')),
      body: AnimatedBuilder(animation: store, builder: (context, _) {
        final items = store.peminjaman.where((p) => p.peminjam == store.currentUser).toList();
        if (items.isEmpty) return const Center(child: Text('Belum ada pengajuan peminjaman.'));
        return ListView.separated(padding: const EdgeInsets.all(16), itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) { final p = items[i]; return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(p.namaAlat, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))), StatusBadge(status: p.status)]),
            const SizedBox(height: 10), Text('Jumlah: ${p.jumlah} unit'), Text('Pinjam: ${fmt(p.tanggalPinjam)} • Kembali: ${fmt(p.tanggalKembali)}'),
            const SizedBox(height: 8), Text('Tujuan: ${p.tujuan}', style: const TextStyle(color: Color(0xFF78849A))),
          ]))); });
      }),
    );
  }
}
