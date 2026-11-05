import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../models/alat.dart';
import 'detail_alat_page.dart';

class DaftarAlatPage extends StatefulWidget {
  const DaftarAlatPage({super.key});
  @override
  State<DaftarAlatPage> createState() => _DaftarAlatPageState();
}
class _DaftarAlatPageState extends State<DaftarAlatPage> {
  final search = TextEditingController();
  String filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar peralatan')),
      body: AnimatedBuilder(animation: store, builder: (context, _) {
        final items = store.alat.where((a) {
          final q = search.text.toLowerCase();
          final match = a.nama.toLowerCase().contains(q) || a.kode.toLowerCase().contains(q);
          return match && (filter == 'Semua' || (filter == 'Tersedia' && a.tersedia > 0) || (filter == 'Habis' && a.tersedia == 0));
        }).toList();
        return Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(16, 6, 16, 12), child: Column(children: [
            TextField(controller: search, onChanged: (_) => setState(() {}), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cari nama atau kode alat')),
            const SizedBox(height: 12),
            SegmentedButton<String>(segments: const [
              ButtonSegment(value: 'Semua', label: Text('Semua')),
              ButtonSegment(value: 'Tersedia', label: Text('Tersedia')),
              ButtonSegment(value: 'Habis', label: Text('Habis')),
            ], selected: {filter}, onSelectionChanged: (v) => setState(() => filter = v.first)),
          ])),
          Expanded(child: items.isEmpty ? const Center(child: Text('Peralatan tidak ditemukan.')) : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20), itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _alatCard(context, items[i])),
          ),
        ]);
      }),
    );
  }

  Widget _alatCard(BuildContext context, Alat alat) => Card(child: InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: alat.tersedia <= 0 ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailAlatPage(alat: alat))).then((_) => setState(() {})),
    child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
      Container(width: 58, height: 58, decoration: BoxDecoration(color: const Color(0xFF3867F4).withValues(alpha: .10), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.handyman_outlined, color: Color(0xFF3867F4), size: 28)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(alat.nama, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 4), Text('${alat.kode} • ${alat.kondisi}', style: const TextStyle(color: Color(0xFF78849A), fontSize: 12)),
        const SizedBox(height: 8), Text('${alat.tersedia} dari ${alat.jumlah} unit tersedia', style: TextStyle(color: alat.tersedia > 0 ? const Color(0xFF16845B) : const Color(0xFFCC4242), fontWeight: FontWeight.w700, fontSize: 12)),
      ])),
      const Icon(Icons.chevron_right_rounded, color: Color(0xFF78849A)),
    ])),
  ));
}
