import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alat.dart';
import '../models/peminjaman.dart';

class AppStore extends ChangeNotifier {
  AppStore._();
  static final AppStore instance = AppStore._();

  final List<Alat> alat = [];
  final List<Peminjaman> peminjaman = [];
  String currentUser = 'Pengguna Demo';
  String currentRole = 'Siswa';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final alatRaw = prefs.getString('alat');
    final pinjamRaw = prefs.getString('peminjaman');
    if (alatRaw != null) {
      alat
        ..clear()
        ..addAll((jsonDecode(alatRaw) as List)
            .map((e) => Alat.fromJson(Map<String, dynamic>.from(e))));
    } else {
      alat.addAll(_defaultAlat());
    }
    if (pinjamRaw != null) {
      peminjaman
        ..clear()
        ..addAll((jsonDecode(pinjamRaw) as List)
            .map((e) => Peminjaman.fromJson(Map<String, dynamic>.from(e))));
    }
    if (alat.isEmpty) alat.addAll(_defaultAlat());
    await _save();
  }

  List<Alat> _defaultAlat() => [
    Alat(id: 'A001', nama: 'Multimeter Digital', kode: 'MT-001', jumlah: 10, tersedia: 8, kondisi: 'Baik', deskripsi: 'Mengukur tegangan, arus, dan hambatan listrik.'),
    Alat(id: 'A002', nama: 'Kabel LAN', kode: 'KL-002', jumlah: 20, tersedia: 15, kondisi: 'Baik', deskripsi: 'Kabel jaringan untuk praktik komputer.'),
    Alat(id: 'A003', nama: 'Tang Crimping', kode: 'TC-003', jumlah: 8, tersedia: 5, kondisi: 'Baik', deskripsi: 'Memasang konektor RJ45 pada kabel jaringan.'),
    Alat(id: 'A004', nama: 'Obeng Set', kode: 'OB-004', jumlah: 12, tersedia: 9, kondisi: 'Rusak Ringan', deskripsi: 'Peralatan untuk membongkar dan memasang perangkat.'),
  ];

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alat', jsonEncode(alat.map((e) => e.toJson()).toList()));
    await prefs.setString('peminjaman', jsonEncode(peminjaman.map((e) => e.toJson()).toList()));
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
    await save();
  }

  Future<void> submitPeminjaman(Peminjaman item) async {
    peminjaman.insert(0, item);
    await save();
  }

  Future<void> updateStatus(Peminjaman item, String status) async {
    final old = item.status;
    item.status = status;
    final equipment = alat.where((e) => e.id == item.alatId).firstOrNull;
    if (equipment != null) {
      if (status == 'Disetujui' && old == 'Menunggu') {
        equipment.tersedia = (equipment.tersedia - item.jumlah).clamp(0, equipment.jumlah);
      } else if (status == 'Ditolak' && old == 'Disetujui') {
        equipment.tersedia = (equipment.tersedia + item.jumlah).clamp(0, equipment.jumlah);
      } else if (status == 'Selesai' && old == 'Dipinjam') {
        equipment.tersedia = (equipment.tersedia + item.jumlah).clamp(0, equipment.jumlah);
      }
    }
    await save();
  }
}
