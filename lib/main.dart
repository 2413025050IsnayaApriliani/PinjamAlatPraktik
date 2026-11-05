
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'data/app_store.dart';
import 'pages/login_page.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
