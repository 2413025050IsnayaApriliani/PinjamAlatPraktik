
import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../models/alat.dart';

class KelolaAlatPage extends StatelessWidget {
  const KelolaAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola data alat'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context, store),
        icon: const Icon(Icons.add),
        label: const Text('Tambah alat'),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          if (store.alat.isEmpty) {
            return const Center(
              child: Text('Belum ada data alat.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
            itemCount: store.alat.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final alat = store.alat[index];

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3867F4).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.handyman_outlined,
                      color: Color(0xFF3867F4),
                    ),
                  ),
                  title: Text(
                    alat.nama,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${alat.kode} • tersedia ${alat.tersedia}/${alat.jumlah}\n'
                    '${alat.kondisi}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: 'Hapus alat',
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFCC4242),
                    ),
                    onPressed: () => _delete(context, store, alat),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showForm(BuildContext context, AppStore store) async {
    final nama = TextEditingController();
    final kode = TextEditingController();
    final jumlah = TextEditingController();
    final deskripsi = TextEditingController();

    String kondisi = 'Baik';

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, setLocal) {
              return AlertDialog(
                title: const Text('Tambah peralatan'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nama,
                        decoration: const InputDecoration(
                          labelText: 'Nama alat',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: kode,
                        decoration: const InputDecoration(
                          labelText: 'Kode alat',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: jumlah,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah unit',
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: kondisi,
                        decoration: const InputDecoration(
                          labelText: 'Kondisi',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Baik',
                            child: Text('Baik'),
                          ),
                          DropdownMenuItem(
                            value: 'Rusak Ringan',
                            child: Text('Rusak ringan'),
                          ),
                          DropdownMenuItem(
                            value: 'Rusak Berat',
                            child: Text('Rusak berat'),
                          ),
                        ],
                        onChanged: (value) {
                          setLocal(() {
                            kondisi = value ?? 'Baik';
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: deskripsi,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final namaAlat = nama.text.trim();
                      final kodeAlat = kode.text.trim();
                      final jumlahAlat = int.tryParse(jumlah.text.trim());

                      if (namaAlat.isEmpty ||
                          kodeAlat.isEmpty ||
                          jumlahAlat == null ||
                          jumlahAlat <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Nama, kode, dan jumlah harus valid.',
                            ),
                          ),
                        );
                        return;
                      }

                      try {
                        await store.addAlat(
                          Alat(
                            id: DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            nama: namaAlat,
                            kode: kodeAlat,
                            jumlah: jumlahAlat,
                            tersedia: jumlahAlat,
                            kondisi: kondisi,
                            deskripsi: deskripsi.text.trim(),
                          ),
                        );

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      } catch (error) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal menyimpan alat: $error'),
                          ),
                        );
                      }
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      nama.dispose();
      kode.dispose();
      jumlah.dispose();
      deskripsi.dispose();
    }
  }

  Future<void> _delete(
    BuildContext context,
    AppStore store,
    Alat alat,
  ) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus peralatan?'),
          content: Text(
            'Data "${alat.nama}" akan dihapus dari inventaris.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (yes == true) {
      try {
        await store.deleteAlat(alat.id);
      } catch (error) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus alat: $error'),
          ),
        );
      }
    }
  }
}
