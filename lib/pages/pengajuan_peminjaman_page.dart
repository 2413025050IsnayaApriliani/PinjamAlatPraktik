import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../models/alat.dart';
import '../models/peminjaman.dart';

class PengajuanPeminjamanPage extends StatefulWidget {
  final Alat alat;
  const PengajuanPeminjamanPage({super.key, required this.alat});
  @override
  State<PengajuanPeminjamanPage> createState() => _PengajuanPeminjamanPageState();
}
class _PengajuanPeminjamanPageState extends State<PengajuanPeminjamanPage> {
  final jumlah = TextEditingController(text: '1');
  final tujuan = TextEditingController();
  DateTime tanggalPinjam = DateTime.now();
  DateTime tanggalKembali = DateTime.now().add(const Duration(days: 1));

  String fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> pilihTanggal(bool kembali) async {
    final picked = await showDatePicker(context: context, initialDate: kembali ? tanggalKembali : tanggalPinjam,
      firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked == null || !mounted) return;
    setState(() { if (kembali) { tanggalKembali = picked; } else { tanggalPinjam = picked; } });
  }

  Future<void> kirim() async {
    final n = int.tryParse(jumlah.text) ?? 0;
    if (n < 1 || n > widget.alat.tersedia) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Jumlah harus 1 sampai ${widget.alat.tersedia}.')));
      return;
    }
    if (tujuan.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tujuan penggunaan wajib diisi.')));
      return;
    }
    if (tanggalKembali.isBefore(tanggalPinjam)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tanggal kembali tidak boleh sebelum tanggal pinjam.')));
      return;
    }
    final store = AppStore.instance;
    await store.submitPeminjaman(Peminjaman(
      id: DateTime.now().microsecondsSinceEpoch.toString(), namaAlat: widget.alat.nama, alatId: widget.alat.id,
      peminjam: store.currentUser, jumlah: n, tanggalPinjam: tanggalPinjam, tanggalKembali: tanggalKembali,
      tujuan: tujuan.text.trim(), status: 'Menunggu'));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengajuan berhasil dikirim.')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ajukan peminjaman')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFF3867F4).withValues(alpha: .08), borderRadius: BorderRadius.circular(20)),
        child: Row(children: [const Icon(Icons.inventory_2_rounded, size: 36, color: Color(0xFF3867F4)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.alat.nama, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('${widget.alat.tersedia} unit tersedia', style: const TextStyle(color: Color(0xFF16845B))),
        ]))])),
      const SizedBox(height: 22),
      TextField(controller: jumlah, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah unit', prefixIcon: Icon(Icons.numbers))),
      const SizedBox(height: 14),
      _dateTile('Tanggal peminjaman', tanggalPinjam, () => pilihTanggal(false)),
      const SizedBox(height: 10), _dateTile('Tanggal pengembalian', tanggalKembali, () => pilihTanggal(true)),
      const SizedBox(height: 14),
      TextField(controller: tujuan, maxLines: 4, decoration: const InputDecoration(labelText: 'Tujuan penggunaan', hintText: 'Contoh: Praktikum jaringan komputer', alignLabelWithHint: true)),
      const SizedBox(height: 24),
      SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: kirim, icon: const Icon(Icons.send_rounded), label: const Text('Kirim pengajuan'))),
    ]),
  );

  Widget _dateTile(String title, DateTime date, VoidCallback onTap) => Card(child: ListTile(onTap: onTap, leading: const Icon(Icons.calendar_month_rounded, color: Color(0xFF3867F4)), title: Text(title), subtitle: Text(fmt(date)), trailing: const Icon(Icons.edit_calendar_outlined)));
}
