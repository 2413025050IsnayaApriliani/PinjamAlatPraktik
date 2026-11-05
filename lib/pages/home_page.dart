import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../widgets/stat_card.dart';
import 'login_page.dart';
import 'daftar_alat_page.dart';
import 'peminjaman_page.dart';
import 'pengajuan_page.dart';
import 'kelola_alat_page.dart';
import 'riwayat_page.dart';

class HomePage extends StatefulWidget {
  final String role;
  final String userName;
  const HomePage({super.key, required this.role, required this.userName});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final isSiswa = widget.role == 'Siswa';
    final waiting = store.peminjaman.where((p) => p.status == 'Menunggu').length;
    final borrowed = store.peminjaman.where((p) => p.status == 'Dipinjam').length;
    return Scaffold(
      appBar: AppBar(title: const Text('PINJAMALAT'), actions: [
        IconButton(tooltip: 'Keluar', onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false), icon: const Icon(Icons.logout_rounded)),
      ]),
      body: AnimatedBuilder(animation: store, builder: (context, _) => ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 28), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF3867F4), Color(0xFF6C8DFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Halo, ${widget.userName}', style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800)),
              const SizedBox(height: 7), Text(isSiswa ? 'Siap untuk praktikum hari ini?' : 'Ringkasan pengelolaan alat praktik.', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 15), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), borderRadius: BorderRadius.circular(30)), child: Text(widget.role, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            ])),
            const Icon(Icons.inventory_2_rounded, size: 62, color: Colors.white),
          ]),
        ),
        const SizedBox(height: 22),
        const Text('Ringkasan inventaris', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.35, children: [
          StatCard(title: 'Jenis peralatan', value: '${store.alat.length}', icon: Icons.inventory_2_outlined, color: const Color(0xFF3867F4)),
          StatCard(title: 'Unit tersedia', value: '${store.alat.fold<int>(0, (s, a) => s + a.tersedia)}', icon: Icons.check_circle_outline, color: const Color(0xFF16845B)),
          StatCard(title: 'Menunggu', value: '$waiting', icon: Icons.hourglass_top_rounded, color: const Color(0xFFB7791F)),
          StatCard(title: 'Sedang dipinjam', value: '$borrowed', icon: Icons.assignment_outlined, color: const Color(0xFF8255D9)),
        ]),
        const SizedBox(height: 24),
        const Text('Menu utama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        if (isSiswa) ...[
          _menu(context, 'Daftar peralatan', 'Cari alat dan lihat ketersediaannya', Icons.inventory_2_outlined, const DaftarAlatPage()),
          const SizedBox(height: 10),
          _menu(context, 'Peminjaman saya', 'Pantau status pengajuan', Icons.assignment_outlined, const PeminjamanPage()),
          const SizedBox(height: 10),
          _menu(context, 'Riwayat peminjaman', 'Lihat transaksi yang sudah selesai', Icons.history_rounded, const RiwayatPage()),
        ] else ...[
          _menu(context, 'Kelola data alat', 'Tambah dan hapus inventaris', Icons.build_outlined, const KelolaAlatPage()),
          const SizedBox(height: 10),
          _menu(context, 'Pengajuan peminjaman', 'Setujui atau tolak pengajuan siswa', Icons.fact_check_outlined, const PengajuanPage()),
          const SizedBox(height: 10),
          _menu(context, 'Riwayat transaksi', 'Lihat peminjaman yang selesai', Icons.history_rounded, const RiwayatPage()),
        ],
      ])),
    );
  }

  Widget _menu(BuildContext context, String title, String subtitle, IconData icon, Widget page) => Card(
    child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: const Color(0xFF3867F4).withValues(alpha: .10), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: const Color(0xFF3867F4))),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF78849A))),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => page)); setState(() {}); },
    ),
  );
}
