import 'package:flutter/material.dart';

void main() {
  runApp(const PinjamAlatApp());
}

class PinjamAlatApp extends StatelessWidget {
  const PinjamAlatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PINJAMALAT',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const LoginPage(),
    );
  }
}

/* =========================================================
   DATA ALAT
========================================================= */

class Alat {
  String id;
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
}

List<Alat> daftarAlat = [
  Alat(
    id: 'A001',
    nama: 'Multimeter Digital',
    kode: 'MT-001',
    jumlah: 10,
    tersedia: 8,
    kondisi: 'Baik',
    deskripsi:
        'Alat ukur elektronik yang digunakan untuk mengukur tegangan, arus, dan hambatan.',
  ),
  Alat(
    id: 'A002',
    nama: 'Kabel LAN',
    kode: 'KL-002',
    jumlah: 20,
    tersedia: 15,
    kondisi: 'Baik',
    deskripsi:
        'Kabel jaringan yang digunakan dalam praktik jaringan komputer.',
  ),
  Alat(
    id: 'A003',
    nama: 'Tang Crimping',
    kode: 'TC-003',
    jumlah: 8,
    tersedia: 5,
    kondisi: 'Baik',
    deskripsi:
        'Alat untuk memasang konektor RJ45 pada kabel jaringan.',
  ),
  Alat(
    id: 'A004',
    nama: 'Obeng Set',
    kode: 'OB-004',
    jumlah: 12,
    tersedia: 9,
    kondisi: 'Rusak Ringan',
    deskripsi:
        'Seperangkat obeng untuk membantu proses pembongkaran dan pemasangan perangkat.',
  ),
];

/* =========================================================
   DATA PEMINJAMAN
========================================================= */

class Peminjaman {
  String id;
  String namaAlat;
  int jumlah;
  String tanggalPinjam;
  String tanggalKembali;
  String tujuan;
  String status;

  Peminjaman({
    required this.id,
    required this.namaAlat,
    required this.jumlah,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.tujuan,
    required this.status,
  });
}

List<Peminjaman> daftarPeminjaman = [];

/* =========================================================
   LOGIN
========================================================= */

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = 'Siswa';

  void login() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password harus diisi.'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Icon(
                Icons.inventory_2_rounded,
                size: 80,
                color: Colors.indigo,
              ),

              const SizedBox(height: 15),

              const Text(
                'PINJAMALAT',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Pengelolaan Peminjaman Peralatan Praktik',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: role,
                decoration: const InputDecoration(
                  labelText: 'Login Sebagai',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Siswa',
                    child: Text('Siswa'),
                  ),
                  DropdownMenuItem(
                    value: 'Guru/Laboran',
                    child: Text('Guru/Laboran'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    role = value!;
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  'Belum punya akun? Register',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   REGISTER
========================================================= */

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final kelasController = TextEditingController();

  String role = 'Siswa';

  void register() {
    if (namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data wajib diisi.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil. Silakan login.'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: role,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Siswa',
                  child: Text('Siswa'),
                ),
                DropdownMenuItem(
                  value: 'Guru/Laboran',
                  child: Text('Guru/Laboran'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            if (role == 'Siswa')
              TextField(
                controller: kelasController,
                decoration: const InputDecoration(
                  labelText: 'Kelas',
                  hintText: 'Contoh: XI TJKT 1',
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: register,
                child: const Text('REGISTER'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================================================
   HOME
========================================================= */

class HomePage extends StatelessWidget {
  final String role;

  const HomePage({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PINJAMALAT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),

                  const SizedBox(width: 15),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        role,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (role == 'Siswa') ...[
            menuButton(
              context,
              'Daftar Peralatan',
              Icons.inventory_2,
              const DaftarAlatPage(),
            ),

            menuButton(
              context,
              'Peminjaman Saya',
              Icons.assignment,
              const PeminjamanPage(),
            ),

            menuButton(
              context,
              'Riwayat Peminjaman',
              Icons.history,
              const RiwayatPage(),
            ),
          ] else ...[
            menuButton(
              context,
              'Kelola Data Alat',
              Icons.inventory,
              const KelolaAlatPage(),
            ),

            menuButton(
              context,
              'Pengajuan Peminjaman',
              Icons.fact_check,
              const PengajuanPage(),
            ),

            menuButton(
              context,
              'Riwayat Transaksi',
              Icons.history,
              const RiwayatPage(),
            ),
          ],
        ],
      ),
    );
  }

  Widget menuButton(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
      ),
    );
  }
}

/* =========================================================
   DAFTAR ALAT
========================================================= */

class DaftarAlatPage extends StatelessWidget {
  const DaftarAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peralatan'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarAlat.length,
        itemBuilder: (context, index) {
          final alat = daftarAlat[index];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.build),
              ),

              title: Text(
                alat.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                '${alat.kode}\n'
                'Tersedia: ${alat.tersedia}/${alat.jumlah}\n'
                'Kondisi: ${alat.kondisi}',
              ),

              isThreeLine: true,

              trailing: alat.tersedia > 0
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailAlatPage(
                              alat: alat,
                            ),
                          ),
                        );
                      },
                      child: const Text('Detail'),
                    )
                  : const Text(
                      'HABIS',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

/* =========================================================
   DETAIL ALAT
========================================================= */

class DetailAlatPage extends StatelessWidget {
  final Alat alat;

  const DetailAlatPage({
    super.key,
    required this.alat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Peralatan'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.inventory_2,
              size: 80,
              color: Colors.indigo,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            alat.nama,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text('Kode Alat: ${alat.kode}'),
          Text('Jumlah: ${alat.jumlah}'),
          Text('Tersedia: ${alat.tersedia}'),
          Text('Kondisi: ${alat.kondisi}'),

          const SizedBox(height: 20),

          const Text(
            'Deskripsi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(alat.deskripsi),

          const SizedBox(height: 25),

          if (alat.tersedia > 0)
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.assignment_add),
                label: const Text('AJUKAN PEMINJAMAN'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PengajuanPeminjamanPage(
                        alat: alat,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/* =========================================================
   FORM PEMINJAMAN
========================================================= */

class PengajuanPeminjamanPage extends StatefulWidget {
  final Alat alat;

  const PengajuanPeminjamanPage({
    super.key,
    required this.alat,
  });

  @override
  State<PengajuanPeminjamanPage> createState() =>
      _PengajuanPeminjamanPageState();
}

class _PengajuanPeminjamanPageState
    extends State<PengajuanPeminjamanPage> {
  final jumlahController = TextEditingController();
  final tujuanController = TextEditingController();

  DateTime tanggalPinjam = DateTime.now();
  DateTime tanggalKembali =
      DateTime.now().add(const Duration(days: 1));

  Future<void> pilihTanggal(bool tanggalKembaliPilih) async {
    final tanggal = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      initialDate: tanggalKembaliPilih
          ? tanggalKembali
          : tanggalPinjam,
    );

    if (tanggal == null) return;

    setState(() {
      if (tanggalKembaliPilih) {
        tanggalKembali = tanggal;
      } else {
        tanggalPinjam = tanggal;
      }
    });
  }

  void kirimPengajuan() {
    final jumlah =
        int.tryParse(jumlahController.text) ?? 0;

    if (jumlah <= 0 ||
        jumlah > widget.alat.tersedia) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Jumlah harus antara 1-${widget.alat.tersedia}.',
          ),
        ),
      );
      return;
    }

    if (tujuanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tujuan peminjaman wajib diisi.'),
        ),
      );
      return;
    }

    if (tanggalKembali.isBefore(tanggalPinjam)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tanggal pengembalian tidak boleh sebelum tanggal peminjaman.',
          ),
        ),
      );
      return;
    }

    daftarPeminjaman.add(
      Peminjaman(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        namaAlat: widget.alat.nama,
        jumlah: jumlah,
        tanggalPinjam:
            '${tanggalPinjam.day}/${tanggalPinjam.month}/${tanggalPinjam.year}',
        tanggalKembali:
            '${tanggalKembali.day}/${tanggalKembali.month}/${tanggalKembali.year}',
        tujuan: tujuanController.text,
        status: 'Menunggu',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pengajuan peminjaman berhasil dikirim.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengajuan Peminjaman',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.alat.nama,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            'Tersedia: ${widget.alat.tersedia}',
          ),

          const SizedBox(height: 20),

          TextField(
            controller: jumlahController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Jumlah yang Dipinjam',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          ListTile(
            tileColor: Colors.white,
            title: const Text(
              'Tanggal Peminjaman',
            ),
            subtitle: Text(
              '${tanggalPinjam.day}/${tanggalPinjam.month}/${tanggalPinjam.year}',
            ),
            trailing: const Icon(
              Icons.calendar_month,
            ),
            onTap: () => pilihTanggal(false),
          ),

          const SizedBox(height: 10),

          ListTile(
            tileColor: Colors.white,
            title: const Text(
              'Tanggal Pengembalian',
            ),
            subtitle: Text(
              '${tanggalKembali.day}/${tanggalKembali.month}/${tanggalKembali.year}',
            ),
            trailing: const Icon(
              Icons.calendar_month,
            ),
            onTap: () => pilihTanggal(true),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: tujuanController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Tujuan Penggunaan',
              hintText:
                  'Contoh: Praktikum jaringan komputer',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: kirimPengajuan,
              child: const Text(
                'KIRIM PENGAJUAN',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   PEMINJAMAN SAYA
========================================================= */

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() =>
      _PeminjamanPageState();
}

class _PeminjamanPageState
    extends State<PeminjamanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Peminjaman Saya',
        ),
      ),

      body: daftarPeminjaman.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pengajuan peminjaman.',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: daftarPeminjaman.length,
              itemBuilder: (context, index) {
                final p =
                    daftarPeminjaman[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.assignment,
                    ),

                    title: Text(
                      p.namaAlat,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      'Jumlah: ${p.jumlah}\n'
                      'Pinjam: ${p.tanggalPinjam}\n'
                      'Kembali: ${p.tanggalKembali}\n'
                      'Tujuan: ${p.tujuan}',
                    ),

                    isThreeLine: true,

                    trailing: Chip(
                      label: Text(p.status),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/* =========================================================
   PENGAJUAN GURU
========================================================= */

class PengajuanPage extends StatefulWidget {
  const PengajuanPage({super.key});

  @override
  State<PengajuanPage> createState() =>
      _PengajuanPageState();
}

class _PengajuanPageState
    extends State<PengajuanPage> {
  void ubahStatus(
    int index,
    String status,
  ) {
    setState(() {
      daftarPeminjaman[index].status =
          status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengajuan Peminjaman',
        ),
      ),

      body: daftarPeminjaman.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pengajuan.',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: daftarPeminjaman.length,
              itemBuilder: (context, index) {
                final p =
                    daftarPeminjaman[index];

                return Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.namaAlat,
                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Jumlah: ${p.jumlah}',
                        ),

                        Text(
                          'Tanggal: ${p.tanggalPinjam} - ${p.tanggalKembali}',
                        ),

                        Text(
                          'Tujuan: ${p.tujuan}',
                        ),

                        const SizedBox(height: 8),

                        Chip(
                          label: Text(
                            p.status,
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (p.status ==
                            'Menunggu')
                          Row(
                            children: [
                              Expanded(
                                child:
                                    ElevatedButton(
                                  onPressed: () {
                                    ubahStatus(
                                      index,
                                      'Disetujui',
                                    );
                                  },
                                  child:
                                      const Text(
                                    'Setujui',
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              Expanded(
                                child:
                                    OutlinedButton(
                                  onPressed: () {
                                    ubahStatus(
                                      index,
                                      'Ditolak',
                                    );
                                  },
                                  child:
                                      const Text(
                                    'Tolak',
                                  ),
                                ),
                              ),
                            ],
                          ),

                        if (p.status ==
                            'Disetujui')
                          SizedBox(
                            width:
                                double.infinity,
                            child:
                                ElevatedButton(
                              onPressed: () {
                                ubahStatus(
                                  index,
                                  'Dipinjam',
                                );
                              },
                              child:
                                  const Text(
                                'Tandai Dipinjam',
                              ),
                            ),
                          ),

                        if (p.status ==
                            'Dipinjam')
                          SizedBox(
                            width:
                                double.infinity,
                            child:
                                ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  p.status =
                                      'Selesai';
                                });

                                ScaffoldMessenger
                                    .of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Pengembalian berhasil dicatat.',
                                    ),
                                  ),
                                );
                              },
                              child:
                                  const Text(
                                'Catat Pengembalian',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/* =========================================================
   KELOLA DATA ALAT
========================================================= */

class KelolaAlatPage extends StatefulWidget {
  const KelolaAlatPage({super.key});

  @override
  State<KelolaAlatPage> createState() =>
      _KelolaAlatPageState();
}

class _KelolaAlatPageState
    extends State<KelolaAlatPage> {
  void tambahAlat() {
    final namaController =
        TextEditingController();
    final kodeController =
        TextEditingController();
    final jumlahController =
        TextEditingController();
    final deskripsiController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Tambah Data Alat',
          ),

          content:
              SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration:
                      const InputDecoration(
                    labelText: 'Nama Alat',
                  ),
                ),

                TextField(
                  controller: kodeController,
                  decoration:
                      const InputDecoration(
                    labelText: 'Kode Alat',
                  ),
                ),

                TextField(
                  controller: jumlahController,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      const InputDecoration(
                    labelText: 'Jumlah',
                  ),
                ),

                TextField(
                  controller:
                      deskripsiController,
                  decoration:
                      const InputDecoration(
                    labelText: 'Deskripsi',
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final jumlah =
                    int.tryParse(
                          jumlahController
                              .text,
                        ) ??
                        0;

                if (namaController
                        .text
                        .isEmpty ||
                    jumlah <= 0) {
                  return;
                }

                setState(() {
                  daftarAlat.add(
                    Alat(
                      id: DateTime.now()
                          .millisecondsSinceEpoch
                          .toString(),
                      nama:
                          namaController.text,
                      kode:
                          kodeController.text,
                      jumlah: jumlah,
                      tersedia: jumlah,
                      kondisi: 'Baik',
                      deskripsi:
                          deskripsiController
                              .text,
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text(
                'Simpan',
              ),
            ),
          ],
        );
      },
    );
  }

  void hapusAlat(int index) {
    setState(() {
      daftarAlat.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Data Alat',
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: tambahAlat,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarAlat.length,
        itemBuilder: (context, index) {
          final alat =
              daftarAlat[index];

          return Card(
            child: ListTile(
              title: Text(
                alat.nama,
              ),

              subtitle: Text(
                '${alat.kode} • '
                '${alat.tersedia}/${alat.jumlah} • '
                '${alat.kondisi}',
              ),

              trailing:
                  PopupMenuButton<String>(
                onSelected: (value) {
                  if (value ==
                      'hapus') {
                    hapusAlat(index);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'hapus',
                    child:
                        Text('Hapus'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/* =========================================================
   RIWAYAT
========================================================= */

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final riwayat =
        daftarPeminjaman.where(
      (p) =>
          p.status == 'Selesai' ||
          p.status == 'Dikembalikan',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Peminjaman',
        ),
      ),

      body: riwayat.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat transaksi.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: riwayat.map((p) {
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),

                    title: Text(
                      p.namaAlat,
                    ),

                    subtitle: Text(
                      'Jumlah: ${p.jumlah}\n'
                      '${p.tanggalPinjam} - '
                      '${p.tanggalKembali}',
                    ),

                    trailing: Text(
                      p.status,
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}