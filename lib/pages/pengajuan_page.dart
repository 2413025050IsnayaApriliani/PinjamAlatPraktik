
import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../models/peminjaman.dart';
import '../widgets/status_badge.dart';

class PengajuanPage extends StatelessWidget {
  const PengajuanPage({super.key});

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
        title: const Text('Pengajuan peminjaman'),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          if (store.peminjaman.isEmpty) {
            return const Center(
              child: Text('Belum ada pengajuan.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: store.peminjaman.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final peminjaman = store.peminjaman[index];

              return _requestCard(context, store, peminjaman);
            },
          );
        },
      ),
    );
  }

  Widget _requestCard(
    BuildContext context,
    AppStore store,
    Peminjaman peminjaman,
  ) {
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
            const SizedBox(height: 8),
            Text(
              'Peminjam: ${peminjaman.peminjam} • '
              '${peminjaman.jumlah} unit',
            ),
            Text(
              '${fmt(peminjaman.tanggalPinjam)} – '
              '${fmt(peminjaman.tanggalKembali)}',
            ),
            const SizedBox(height: 6),
            Text(
              'Tujuan: ${peminjaman.tujuan}',
              style: const TextStyle(
                color: Color(0xFF78849A),
              ),
            ),
            const SizedBox(height: 14),

            if (peminjaman.status == 'Menunggu')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _confirm(
                        context,
                        () => store.updateStatus(
                          peminjaman,
                          'Ditolak',
                        ),
                      ),
                      child: const Text('Tolak'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final alat = store.alat
                            .where((a) => a.id == peminjaman.alatId)
                            .firstOrNull;

                        if (alat == null ||
                            alat.tersedia < peminjaman.jumlah) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Stok tidak mencukupi untuk '
                                'menyetujui pengajuan.',
                              ),
                            ),
                          );
                          return;
                        }

                        await store.updateStatus(
                          peminjaman,
                          'Disetujui',
                        );
                      },
                      child: const Text('Setujui'),
                    ),
                  ),
                ],
              ),

            if (peminjaman.status == 'Disetujui')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => store.updateStatus(
                    peminjaman,
                    'Dipinjam',
                  ),
                  child: const Text('Tandai sedang dipinjam'),
                ),
              ),

            if (peminjaman.status == 'Dipinjam')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => store.updateStatus(
                    peminjaman,
                    'Selesai',
                  ),
                  icon: const Icon(
                    Icons.assignment_turned_in_outlined,
                  ),
                  label: const Text('Catat pengembalian'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tolak pengajuan?'),
        content: const Text(
          'Pengajuan akan ditandai sebagai ditolak.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, tolak'),
          ),
        ],
      ),
    );

    if (yes == true) {
      await action();
    }
  }
}
