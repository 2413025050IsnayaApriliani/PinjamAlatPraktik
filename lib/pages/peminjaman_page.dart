
import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../widgets/status_badge.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

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
        title: const Text('Peminjaman saya'),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final items = store.peminjaman
              .where((p) => p.peminjam == store.currentUser)
              .toList();

          if (items.isEmpty) {
            return const Center(
              child: Text('Belum ada pengajuan peminjaman.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final peminjaman = items[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              peminjaman.namaAlat,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          StatusBadge(status: peminjaman.status),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Jumlah: ${peminjaman.jumlah} unit'),
                      Text(
                        'Pinjam: ${fmt(peminjaman.tanggalPinjam)}'
                        ' • Kembali: ${fmt(peminjaman.tanggalKembali)}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tujuan: ${peminjaman.tujuan}',
                        style: const TextStyle(
                          color: Color(0xFF78849A),
                        ),
                      ),
                    ],
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
