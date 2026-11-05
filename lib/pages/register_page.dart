import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final nama = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final kelas = TextEditingController();
  String role = 'Siswa';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Buat akun')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Daftar PINJAMALAT', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8), const Text('Lengkapi informasi akun di bawah ini.', style: TextStyle(color: Color(0xFF78849A))),
      const SizedBox(height: 22),
      TextField(controller: nama, decoration: const InputDecoration(labelText: 'Nama lengkap', prefixIcon: Icon(Icons.person_outline))),
      const SizedBox(height: 13),
      TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
      const SizedBox(height: 13),
      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline))),
      const SizedBox(height: 13),
      DropdownButtonFormField<String>(value: role, decoration: const InputDecoration(labelText: 'Daftar sebagai'),
        items: const [DropdownMenuItem(value: 'Siswa', child: Text('Siswa')), DropdownMenuItem(value: 'Guru/Laboran', child: Text('Guru/Laboran'))],
        onChanged: (v) => setState(() => role = v ?? 'Siswa')),
      if (role == 'Siswa') ...[const SizedBox(height: 13), TextField(controller: kelas, decoration: const InputDecoration(labelText: 'Kelas', hintText: 'Contoh: XI TJKT 1'))],
      const SizedBox(height: 24),
      ElevatedButton(onPressed: () {
        if (nama.text.trim().isEmpty || email.text.trim().isEmpty || password.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama, email, dan password wajib diisi.')));
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form valid. Mode demo belum menyimpan akun ke server.')));
        Navigator.pop(context);
      }, child: const Text('Buat akun')),
    ]),
  );
}
