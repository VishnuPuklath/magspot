import 'package:flutter/material.dart';
import 'package:magspot/core/theme/theme.dart';
import 'package:magspot/features/auth/presentation/pages/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Magazine App',
        theme: AppTheme.darkModeTheme,
        home: const LoginPage());
  }
}
