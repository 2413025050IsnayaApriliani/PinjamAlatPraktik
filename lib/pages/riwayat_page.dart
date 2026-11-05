
import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../widgets/status_badge.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  String fmt(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat transaksi'),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final items = store.peminjaman
              .where(
                (p) =>
                    p.status == 'Selesai' ||
                    p.status == 'Ditolak',
              )
              .toList();

          if (items.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat transaksi.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final peminjaman = items[index];
              final selesai = peminjaman.status == 'Selesai';

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Icon(
                    selesai
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: selesai
                        ? const Color(0xFF16845B)
                        : const Color(0xFFCC4242),
                  ),
                  title: Text(
                    peminjaman.namaAlat,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    '${peminjaman.peminjam} • '
                    '${peminjaman.jumlah} unit\n'
                    '${fmt(peminjaman.tanggalPinjam)} – '
                    '${fmt(peminjaman.tanggalKembali)}',
                  ),
                  isThreeLine: true,
                  trailing: StatusBadge(
                    status: peminjaman.status,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
