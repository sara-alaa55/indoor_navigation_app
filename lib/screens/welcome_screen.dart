import 'package:flutter/material.dart';
import 'practical_screen.dart';
import 'theory_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // متغير للتحكم في الثيم (فاتح / غامق)
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان بناءً على المود النشط
    final backgroundColor = _isDarkMode
        ? const Color(0xFF0A0A0A)
        : Colors.grey[100];
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final pinkColor = const Color(0xFFFFB6C1);

    return Scaffold(
      backgroundColor: backgroundColor,
      // أيقونة تبديل الثيم في الأعلى
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: pinkColor,
            ),
          ),
        ],
      ),
      body: Center(
        // FittedBox هنا بيضمن إن كل المحتويات تصغر وتكبر حسب مقاس الشاشة
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة اللوكيشن
                Icon(Icons.location_on_rounded, size: 55, color: pinkColor),
                const SizedBox(height: 12),
                Text(
                  "SCHOOL NAVIGATOR",
                  style: TextStyle(
                    color: pinkColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Choose your destination building",
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 45),

                // زر مبنى العملي
                _buildSlimButton(
                  context,
                  "PRACTICAL BUILDING",
                  "مبنى العملي",
                  Icons.science_outlined,
                  const PracticalScreen(),
                ),

                const SizedBox(height: 18),

                // زر مبنى النظري
                _buildSlimButton(
                  context,
                  "THEORY BUILDING",
                  "مبنى النظري",
                  Icons.menu_book_rounded,
                  const TheoryScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ويجيت لإنشاء المستطيلات الكنزة (Slim Buttons)
  Widget _buildSlimButton(
    BuildContext context,
    String title,
    String sub,
    IconData icon,
    Widget screen,
  ) {
    final isDark = _isDarkMode;
    final pinkColor = const Color(0xFFFFB6C1);

    // حساب العرض بناءً على نوع الشاشة (موبايل vs لاب توب)
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth > 600
        ? screenWidth * 0.35
        : screenWidth * 0.85;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      child: Container(
        width: buttonWidth,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: pinkColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: pinkColor, size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: pinkColor, size: 14),
          ],
        ),
      ),
    );
  }
}
