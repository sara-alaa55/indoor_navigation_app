import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(const SchoolNavApp());

class SchoolNavApp extends StatelessWidget {
  const SchoolNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFFFFB6C1),
      ),
      home: const WelcomeScreen(),
    );
  }
}
