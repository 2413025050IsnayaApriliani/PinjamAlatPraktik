class Alat {
  final String id;
  String nama;
  String kode;
  int jumlah;
  int tersedia;
  String kondisi;
  String deskripsi;

  Alat({
    required this.id,
    required this.nama,
    required this.kode,
    required this.jumlah,
    required this.tersedia,
    required this.kondisi,
    required this.deskripsi,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'nama': nama, 'kode': kode, 'jumlah': jumlah,
    'tersedia': tersedia, 'kondisi': kondisi, 'deskripsi': deskripsi,
  };

  factory Alat.fromJson(Map<String, dynamic> json) => Alat(
    id: json['id'] as String,
    nama: json['nama'] as String,
    kode: json['kode'] as String,
    jumlah: json['jumlah'] as int,
    tersedia: json['tersedia'] as int,
    kondisi: json['kondisi'] as String,
    deskripsi: json['deskripsi'] as String? ?? '',
  );
}
