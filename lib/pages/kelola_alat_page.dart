import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../models/alat.dart';

class KelolaAlatPage extends StatelessWidget {
  const KelolaAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return Scaffold(appBar: AppBar(title: const Text('Kelola data alat')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _showForm(context, store), icon: const Icon(Icons.add), label: const Text('Tambah alat')),
      body: AnimatedBuilder(animation: store, builder: (context, _) {
        if (store.alat.isEmpty) return const Center(child: Text('Belum ada data alat.'));
        return ListView.separated(padding: const EdgeInsets.fromLTRB(16, 6, 16, 90), itemCount: store.alat.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) { final a = store.alat[i]; return Card(child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF3867F4).withValues(alpha: .1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.handyman_outlined, color: Color(0xFF3867F4))),
            title: Text(a.nama, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('${a.kode} • tersedia ${a.tersedia}/${a.jumlah}\n${a.kondisi}'),
            isThreeLine: true,
            trailing: IconButton(tooltip: 'Hapus alat', icon: const Icon(Icons.delete_outline, color: Color(0xFFCC4242)), onPressed: () => _delete(context, store, a)),
          )); });
      }),
    );
  }

  Future<void> _showForm(BuildContext context, AppStore store) async {
    final nama = TextEditingController(), kode = TextEditingController(), jumlah = TextEditingController(), deskripsi = TextEditingController();
    String kondisi = 'Baik';
    await showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setLocal) => AlertDialog(
      title: const Text('Tambah peralatan'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nama, decoration: const InputDecoration(labelText: 'Nama alat')),
        const SizedBox(height: 10), TextField(controller: kode, decoration: const InputDecoration(labelText: 'Kode alat')),
        const SizedBox(height: 10), TextField(controller: jumlah, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah unit')),
        const SizedBox(height: 10), DropdownButtonFormField<String>(value: kondisi, decoration: const InputDecoration(labelText: 'Kondisi'),
          items: const [DropdownMenuItem(value: 'Baik', child: Text('Baik')), DropdownMenuItem(value: 'Rusak Ringan', child: Text('Rusak ringan')), DropdownMenuItem(value: 'Rusak Berat', child: Text('Rusak berat'))],
          onChanged: (v) => setLocal(() => kondisi = v ?? 'Baik')),
        const SizedBox(height: 10), TextField(controller: deskripsi, maxLines: 2, decoration: const InputDecoration(labelText: 'Deskripsi')),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
        ElevatedButton(onPressed: () async {
          final n = int.tryParse(jumlah.text) ?? 0;
          if (nama.text.trim().isEmpty || kode.text.trim().isEmpty || n <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama, kode, dan jumlah harus valid.'))); return;
          }
          await store.addAlat(Alat(id: DateTime.now().microsecondsSinceEpoch.toString(), nama: nama.text.trim(), kode: kode.text.trim(), jumlah: n, tersedia: n, kondisi: kondisi, deskripsi: deskripsi.text.trim()));
          if (ctx.mounted) Navigator.pop(ctx);
        }, child: const Text('Simpan')),
      ],
    )));
  }

  Future<void> _delete(BuildContext context, AppStore store, Alat alat) async {
    final yes = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Hapus peralatan?'), content: Text('Data "${alat.nama}" akan dihapus dari inventaris.'),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')), ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus'))],
    ));
    if (yes == true) await store.deleteAlat(alat.id);
  }
}
