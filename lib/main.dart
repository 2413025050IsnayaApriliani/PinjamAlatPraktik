import 'package:flutter/material.dart';
import 'data/app_store.dart';
import 'pages/login_page.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStore.instance.load();
  runApp(const PinjamAlatApp());
}

class PinjamAlatApp extends StatelessWidget {
  const PinjamAlatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PINJAMALAT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginPage(),
    );
  }
}
