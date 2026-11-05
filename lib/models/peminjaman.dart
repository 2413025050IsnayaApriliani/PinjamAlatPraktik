class Peminjaman {
  final String id;
  final String namaAlat;
  final String alatId;
  final String peminjam;
  final int jumlah;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembali;
  final String tujuan;
  String status;

  Peminjaman({
    required this.id,
    required this.namaAlat,
    required this.alatId,
    required this.peminjam,
    required this.jumlah,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.tujuan,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'namaAlat': namaAlat, 'alatId': alatId, 'peminjam': peminjam,
    'jumlah': jumlah, 'tanggalPinjam': tanggalPinjam.toIso8601String(),
    'tanggalKembali': tanggalKembali.toIso8601String(),
    'tujuan': tujuan, 'status': status,
  };

  factory Peminjaman.fromJson(Map<String, dynamic> json) => Peminjaman(
    id: json['id'] as String,
    namaAlat: json['namaAlat'] as String,
    alatId: json['alatId'] as String? ?? '',
    peminjam: json['peminjam'] as String? ?? 'Siswa',
    jumlah: json['jumlah'] as int,
    tanggalPinjam: DateTime.parse(json['tanggalPinjam'] as String),
    tanggalKembali: DateTime.parse(json['tanggalKembali'] as String),
    tujuan: json['tujuan'] as String,
    status: json['status'] as String,
  );
}
