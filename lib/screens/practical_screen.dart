import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'qr_scanner_screen.dart';
import 'theory_screen.dart';
import 'welcome_screen.dart';

class PracticalScreen extends StatefulWidget {
  const PracticalScreen({super.key});

  @override
  State<PracticalScreen> createState() => _PracticalScreenState();
}

class _PracticalScreenState extends State<PracticalScreen>
    with SingleTickerProviderStateMixin {
  bool _isDarkMode = true;
  String _selectedDestination = "";
  String _searchQuery = "";

  Offset _lastPosition = const Offset(0.5, 0.9);
  Offset _startPosition = const Offset(0.5, 0.9);
  Offset _targetPosition = const Offset(0.5, 0.9);

  late AnimationController _controller;
  late Animation<double> _animation;

  final Map<String, Offset> _locations = {
    "Entrance": const Offset(0.5, 0.9),
    "Reception": const Offset(0.5, 0.9),
    "Emergency Exit": const Offset(0.5, 0.08),
    "COO Office": const Offset(0.19, 0.15),
    "Cafeteria": const Offset(0.55, 0.25),
    "Ms. Asmaa": const Offset(0.24, 0.42),
    "Mr. Salah": const Offset(0.32, 0.42),
    "Data Center": const Offset(0.40, 0.42),
    "Maintenance": const Offset(0.32, 0.51),
    "Lab 2": const Offset(0.40, 0.51),
    "Boys WC": const Offset(0.68, 0.42),
    "Girls WC": const Offset(0.76, 0.42),
    "AI Lab": const Offset(0.76, 0.51),
    "Lab 1": const Offset(0.94, 0.46),
    "LAB 4": const Offset(0.14, 0.05),
    "Lab 3": const Offset(0.14, 0.15),
    "Staff Room": const Offset(0.14, 0.25),
  };

  int _calculateStepsBetween(Offset from, Offset to) {
    double dx = (from.dx - to.dx).abs();
    double dy = (from.dy - to.dy).abs();
    return ((dx + dy) * 100).toInt();
  }

  void _updatePath(String dest) {
    if (!_locations.containsKey(dest)) return;
    Offset newTarget = _locations[dest]!;
    if (_lastPosition == newTarget) return;
    setState(() {
      _startPosition = _lastPosition;
      _targetPosition = newTarget;
      _selectedDestination = dest;
    });
    _controller.reset();
    _controller.forward();
  }

  void _onAnimationComplete() {
    setState(() {
      _lastPosition = _targetPosition;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutExpo,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFF5F5F5);
    final sidebarColor = _isDarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        children: [
          Container(
            width: 300,
            color: sidebarColor,
            child: _buildSidebar(textColor),
          ),
          Expanded(
            child: Stack(
              children: [_buildMapSection(), _buildFloatingButtons(context)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(Color textColor) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "PRACTICAL",
                style: TextStyle(
                  color: Color(0xFFFFB6C1),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: const Color(0xFFFFB6C1),
                ),
                onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Search room...",
              hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB6C1)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildFolder(Icons.school_outlined, "Learning Hub", [
                "Lab 1",
                "Lab 2",
                "Lab 3",
                "LAB 4",
                "AI Lab",
              ], textColor),
              _buildFolder(Icons.work_outline, "Management", [
                "COO Office",
                "Ms. Asmaa",
                "Mr. Salah",
                "Data Center",
                "Maintenance",
                "Staff Room",
              ], textColor),
              _buildFolder(Icons.wc, "W.C", ["Boys WC", "Girls WC"], textColor),
              _buildFolder(Icons.more_horiz, "Others", [
                "Entrance",
                "Emergency Exit",
                "Cafeteria",
                "Reception",
              ], textColor),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  label: const Text(
                    "BACK",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB6C1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFolder(
    IconData icon,
    String title,
    List<String> items,
    Color txtColor,
  ) {
    List<String> filtered = items
        .where((i) => i.toLowerCase().contains(_searchQuery))
        .toList();
    if (filtered.isEmpty && _searchQuery.isNotEmpty)
      return const SizedBox.shrink();

    return ExpansionTile(
      leading: Icon(icon, color: const Color(0xFFFFB6C1)),
      title: Text(
        title,
        style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
      ),
      iconColor: const Color(0xFFFFB6C1),
      collapsedIconColor: const Color(0xFFFFB6C1),
      children: filtered
          .map(
            (item) => ListTile(
              contentPadding: const EdgeInsets.only(left: 70),
              title: Text(
                item,
                style: TextStyle(
                  color: _selectedDestination == item
                      ? const Color(0xFFFFB6C1)
                      : txtColor.withOpacity(0.7),
                ),
              ),
              onTap: () => _updatePath(item),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMapSection() {
    int steps = _calculateStepsBetween(_startPosition, _targetPosition);

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF151515) : Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) => CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: SmartNeonPainter(
                      progress: _animation.value,
                      startNode: _startPosition,
                      targetNode: _targetPosition,
                      isDarkMode: _isDarkMode,
                      stepCount: steps.toString(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: Column(
        children: [
          FloatingActionButton.extended(
            heroTag: "theory_btn",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TheoryScreen()),
            ),
            label: const Text(
              "Theory",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.apartment, color: Colors.black),
            backgroundColor: const Color(0xFFFFB6C1),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            heroTag: "qr_btn",
            onPressed: () async {
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRScannerScreen(),
                ),
              );
              if (res != null && _locations.containsKey(res)) {
                _updatePath(res);
              }
            },
            backgroundColor: const Color(0xFFFFB6C1),
            child: const Icon(Icons.qr_code_scanner, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class SmartNeonPainter extends CustomPainter {
  final double progress;
  final Offset startNode;
  final Offset targetNode;
  final String stepCount;
  final bool isDarkMode;

  SmartNeonPainter({
    required this.progress,
    required this.startNode,
    required this.targetNode,
    required this.stepCount,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pinkNeon = const Color(0xFFFFB6C1);

    final corridorPaint = Paint()
      ..color = isDarkMode
          ? Colors.white.withOpacity(0.05)
          : Colors.grey.withOpacity(0.1);

    // الممر الطولي الرئيسي (اللي في النص)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.46, h * 0.05, w * 0.08, h * 0.9),
      corridorPaint,
    );

    // الممر العرضي (اللي يربط كل حاجة)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.1, h * 0.42, w * 0.85, h * 0.08),
      corridorPaint,
    );

    // الممر الأيسر (اللي بيودي لـ Lab 4 و Lab 3 و Staff Room)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.1, h * 0.05, w * 0.08, h * 0.37),
      corridorPaint,
    );

    // 🔥 تم إزالة الممر الأيمن (اللي كان بيودي لـ Lab 1)

    _drawStaticRooms(canvas, size);

    final path = Path();

    double sX = startNode.dx * w;
    double sY = startNode.dy * h;
    double tX = targetNode.dx * w;
    double tY = targetNode.dy * h;

    double centerMainX = w * 0.5;
    double centerHorY = h * 0.46;
    double centerLeftX = w * 0.14;
    double centerRightX = w * 0.94;

    path.moveTo(sX, sY);

    // التحرك من البداية لنص الممر العرضي
    if (sX < w * 0.2) {
      // لو البداية في الممر الأيسر
      path.lineTo(centerLeftX, sY);
      path.lineTo(centerLeftX, centerHorY);
    } else if (sX > w * 0.85) {
      // لو البداية في الممر الأيمن
      path.lineTo(centerRightX, sY);
      path.lineTo(centerRightX, centerHorY);
    } else {
      // لو البداية في أي مكان تاني
      path.lineTo(sX, centerHorY);
    }

    // التحرك من الممر العرضي للهدف
    if (tX < w * 0.2) {
      // لو الهدف في الممر الأيسر
      path.lineTo(centerLeftX, centerHorY);
      path.lineTo(centerLeftX, tY);
    } else if (tX > w * 0.85) {
      // لو الهدف في الممر الأيمن
      path.lineTo(centerRightX, centerHorY);
      path.lineTo(centerRightX, tY);
    } else {
      // لو الهدف في أي مكان تاني
      path.lineTo(tX, centerHorY);
    }

    // النزول للهدف
    path.lineTo(tX, tY);

    final metrics = path.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final metric = metrics.first;
      final currentPath = metric.extractPath(0, metric.length * progress);

      canvas.drawPath(
        currentPath,
        Paint()
          ..color = pinkNeon.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );

      canvas.drawPath(
        currentPath,
        Paint()
          ..color = pinkNeon
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );

      final tangent = metric.getTangentForOffset(metric.length * progress);
      if (tangent != null) {
        _drawPersonMarker(canvas, tangent.position, pinkNeon);
        int steps = 0;
        if (stepCount.isNotEmpty) {
          steps = (int.parse(stepCount) * progress).toInt();
        }
        _drawStepBubble(canvas, tangent.position, steps);
      }
    }
  }

  void _drawStaticRooms(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pColor = const Color(0xFFC78C9D);
    final tColor = const Color(0xFF6A9EA2);

    void drawR(
      String label,
      double x,
      double y,
      double width,
      double height,
      Color color,
    ) {
      final rect = Rect.fromLTWH(x * w, y * h, width * w, height * h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()..color = color.withOpacity(0.6),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          rect.left + (rect.width - tp.width) / 2,
          rect.top + (rect.height - tp.height) / 2,
        ),
      );
    }

    drawR("COO Office", 0.19, 0.12, 0.08, 0.06, pColor);
    drawR("Ms. Asmaa", 0.21, 0.35, 0.07, 0.06, pColor);
    drawR("Mr. Salah", 0.29, 0.35, 0.07, 0.06, tColor);
    drawR("Data Center", 0.37, 0.35, 0.09, 0.06, tColor);
    drawR("Boys WC", 0.68, 0.35, 0.07, 0.06, tColor);
    drawR("Girls WC", 0.76, 0.35, 0.07, 0.06, tColor);
    drawR("Cafeteria", 0.55, 0.22, 0.10, 0.06, pColor);
    drawR("Staff Room", 0.01, 0.22, 0.08, 0.06, pColor);
    drawR("Lab 3", 0.01, 0.12, 0.08, 0.06, tColor);
    drawR("LAB 4", 0.09, 0.01, 0.1, 0.04, tColor);
    drawR("EXIT", 0.45, 0.01, 0.1, 0.05, Colors.red);
    drawR("Maintenance", 0.29, 0.51, 0.07, 0.06, pColor);
    drawR("Lab 2", 0.37, 0.51, 0.07, 0.06, tColor);
    drawR("AI Lab", 0.72, 0.51, 0.10, 0.06, pColor);
    drawR("Reception", 0.44, 0.90, 0.12, 0.06, pColor);
    drawR("Lab 1", 0.94, 0.42, 0.05, 0.08, tColor);
  }

  void _drawPersonMarker(Canvas canvas, Offset pos, Color color) {
    canvas.drawCircle(pos, 12, Paint()..color = color);
    final tp = TextPainter(
      text: const TextSpan(text: '🚶', style: TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawStepBubble(Canvas canvas, Offset pos, int steps) {
    final rect = Rect.fromLTWH(pos.dx - 30, pos.dy - 55, 60, 30);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()..color = const Color(0xFFFFB6C1),
    );
    final tp = TextPainter(
      text: TextSpan(
        text: "$steps steps",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(
        rect.left + (rect.width - tp.width) / 2,
        rect.top + (rect.height - tp.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
