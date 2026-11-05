import 'package:flutter/material.dart';
import '../data/app_store.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'Siswa';
  bool obscure = true;

  void login() {
    if (nameController.text.trim().isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama/email dan password harus diisi.')));
      return;
    }
    AppStore.instance.currentUser = nameController.text.trim();
    AppStore.instance.currentRole = role;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage(role: role, userName: nameController.text.trim())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: const Color(0xFF3867F4), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 32)),
          const SizedBox(height: 28),
          const Text('PINJAMALAT', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900, color: Color(0xFF14213D))),
          const SizedBox(height: 8),
          const Text('Kelola peminjaman peralatan praktik dengan lebih mudah.', style: TextStyle(color: Color(0xFF78849A), height: 1.5)),
          const SizedBox(height: 30),
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama atau email', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 14),
          TextField(controller: passwordController, obscureText: obscure, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => setState(() => obscure = !obscure)))),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(value: role, decoration: const InputDecoration(labelText: 'Masuk sebagai', prefixIcon: Icon(Icons.badge_outlined)),
            items: const [DropdownMenuItem(value: 'Siswa', child: Text('Siswa')), DropdownMenuItem(value: 'Guru/Laboran', child: Text('Guru/Laboran'))],
            onChanged: (v) => setState(() => role = v ?? 'Siswa')),
          const SizedBox(height: 22),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: login, icon: const Icon(Icons.login), label: const Text('Masuk ke aplikasi'))),
          const SizedBox(height: 10),
          Center(child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())), child: const Text('Belum punya akun? Buat akun'))),
          const SizedBox(height: 8),
          const Center(child: Text('Mode demo: isi nama dan password apa saja', style: TextStyle(color: Color(0xFF8B96A8), fontSize: 12))),
        ])),
      ))),
    );
  }
}
