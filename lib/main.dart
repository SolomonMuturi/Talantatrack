import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TalentTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          surface: const Color(0xFF0D0D0D),
        ),
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1A1A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white10),
          ),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
