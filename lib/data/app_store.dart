
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alat.dart';
import '../models/peminjaman.dart';

class AppStore extends ChangeNotifier {
  AppStore._();

  static final AppStore instance = AppStore._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<Alat> alat = [];
  final List<Peminjaman> peminjaman = [];

  String currentUser = 'Pengguna Demo';
  String currentRole = 'Siswa';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil data lokal sebagai cadangan atau sumber migrasi awal.
    final alatRaw = prefs.getString('alat');
    final pinjamRaw = prefs.getString('peminjaman');

    final alatLokal = alatRaw == null
        ? <Alat>[]
        : (jsonDecode(alatRaw) as List)
            .map((e) => Alat.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList();

    final pinjamanLokal = pinjamRaw == null
        ? <Peminjaman>[]
        : (jsonDecode(pinjamRaw) as List)
            .map((e) => Peminjaman.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList();

    // Baca data alat dari Firestore.
    final alatSnapshot = await _db.collection('alat').get();

    alat.clear();

    if (alatSnapshot.docs.isNotEmpty) {
      alat.addAll(
        alatSnapshot.docs.map(
          (doc) => Alat.fromJson(doc.data()),
        ),
      );
    } else if (alatLokal.isNotEmpty) {
      // Migrasikan data lokal jika collection masih kosong.
      alat.addAll(alatLokal);
    } else {
      alat.addAll(_defaultAlat());
    }

    // Baca data peminjaman dari Firestore.
    final pinjamSnapshot =
        await _db.collection('peminjaman').get();

    peminjaman.clear();

    if (pinjamSnapshot.docs.isNotEmpty) {
      peminjaman.addAll(
        pinjamSnapshot.docs.map(
          (doc) => Peminjaman.fromJson(doc.data()),
        ),
      );
    } else {
      // Migrasikan pengajuan lokal jika belum ada di cloud.
      peminjaman.addAll(pinjamanLokal);
    }

    // Pertahankan data alat bawaan yang belum tersedia.
    final idsYangAda = alat.map((item) => item.id).toSet();

    for (final item in _defaultAlat()) {
      if (idsYangAda.add(item.id)) {
        alat.add(item);
      }
    }

    // Simpan data yang dimuat dan migrasikan ke Firestore.
    await _save();
    notifyListeners();
  }

  List<Alat> _defaultAlat() => [
        Alat(
          id: 'A001',
          nama: 'Multimeter Digital',
          kode: 'MT-001',
          jumlah: 10,
          tersedia: 8,
          kondisi: 'Baik',
          deskripsi:
              'Mengukur tegangan, arus, dan hambatan listrik.',
        ),
        Alat(
          id: 'A002',
          nama: 'Kabel LAN',
          kode: 'KL-002',
          jumlah: 20,
          tersedia: 15,
          kondisi: 'Baik',
          deskripsi: 'Kabel jaringan untuk praktik komputer.',
        ),
        Alat(
          id: 'A003',
          nama: 'Tang Crimping',
          kode: 'TC-003',
          jumlah: 8,
          tersedia: 5,
          kondisi: 'Baik',
          deskripsi:
              'Memasang konektor RJ45 pada kabel jaringan.',
        ),
        Alat(
          id: 'A004',
          nama: 'Obeng Set',
          kode: 'OB-004',
          jumlah: 12,
          tersedia: 9,
          kondisi: 'Rusak Ringan',
          deskripsi:
              'Peralatan untuk membongkar dan memasang perangkat.',
        ),
        Alat(
          id: 'A005',
          nama: 'Laptop',
          kode: 'LP-005',
          jumlah: 10,
          tersedia: 8,
          kondisi: 'Baik',
          deskripsi:
              'Laptop untuk praktik pemrograman dan administrasi.',
        ),
        Alat(
          id: 'A006',
          nama: 'Komputer Desktop',
          kode: 'KD-006',
          jumlah: 15,
          tersedia: 12,
          kondisi: 'Baik',
          deskripsi:
              'Komputer untuk praktik perangkat lunak dan jaringan.',
        ),
        Alat(
          id: 'A007',
          nama: 'Keyboard',
          kode: 'KB-007',
          jumlah: 20,
          tersedia: 18,
          kondisi: 'Baik',
          deskripsi:
              'Perangkat input untuk komputer desktop.',
        ),
        Alat(
          id: 'A008',
          nama: 'Mouse',
          kode: 'MS-008',
          jumlah: 20,
          tersedia: 17,
          kondisi: 'Baik',
          deskripsi:
              'Perangkat penunjuk untuk mengoperasikan komputer.',
        ),
        Alat(
          id: 'A009',
          nama: 'Router',
          kode: 'RT-009',
          jumlah: 6,
          tersedia: 4,
          kondisi: 'Baik',
          deskripsi:
              'Perangkat untuk praktik konfigurasi jaringan.',
        ),
        Alat(
          id: 'A010',
          nama: 'Switch Jaringan',
          kode: 'SW-010',
          jumlah: 8,
          tersedia: 6,
          kondisi: 'Baik',
          deskripsi:
              'Menghubungkan beberapa perangkat dalam jaringan LAN.',
        ),
        Alat(
          id: 'A011',
          nama: 'Tang Potong',
          kode: 'TP-011',
          jumlah: 8,
          tersedia: 7,
          kondisi: 'Baik',
          deskripsi:
              'Memotong kabel saat praktik instalasi jaringan.',
        ),
        Alat(
          id: 'A012',
          nama: 'Konektor RJ45',
          kode: 'RJ-012',
          jumlah: 100,
          tersedia: 85,
          kondisi: 'Baik',
          deskripsi:
              'Konektor untuk terminasi kabel jaringan Ethernet.',
        ),
      ];

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    // Cadangan lokal.
    await prefs.setString(
      'alat',
      jsonEncode(alat.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(
      'peminjaman',
      jsonEncode(peminjaman.map((e) => e.toJson()).toList()),
    );

    // Simpan data alat ke Firestore.
    for (final item in alat) {
      await _db.collection('alat').doc(item.id).set(
            item.toJson(),
          );
    }

    // Simpan data peminjaman ke Firestore.
    for (final item in peminjaman) {
      await _db.collection('peminjaman').doc(item.id).set(
            item.toJson(),
          );
    }
  }

  Future<void> save() async {
    await _save();
    notifyListeners();
  }

  Future<void> addAlat(Alat item) async {
    alat.add(item);
    await save();
  }

  Future<void> deleteAlat(String id) async {
    alat.removeWhere((e) => e.id == id);

    // Hapus juga dokumen alat di cloud.
    await _db.collection('alat').doc(id).delete();

    await save();
  }

  Future<void> submitPeminjaman(Peminjaman item) async {
    peminjaman.insert(0, item);
    await save();
  }

  Future<void> updateStatus(
    Peminjaman item,
    String status,
  ) async {
    final old = item.status;
    item.status = status;

    final equipment =
        alat.where((e) => e.id == item.alatId).firstOrNull;

    if (equipment != null) {
      if (status == 'Disetujui' && old == 'Menunggu') {
        equipment.tersedia =
            (equipment.tersedia - item.jumlah)
                .clamp(0, equipment.jumlah);
      } else if (status == 'Ditolak' &&
          old == 'Disetujui') {
        equipment.tersedia =
            (equipment.tersedia + item.jumlah)
                .clamp(0, equipment.jumlah);
      } else if (status == 'Selesai' &&
          old == 'Dipinjam') {
        equipment.tersedia =
            (equipment.tersedia + item.jumlah)
                .clamp(0, equipment.jumlah);
      }
    }

    await save();
  }
}
