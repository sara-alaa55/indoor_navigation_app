import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'qr_scanner_screen.dart';

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
  late AnimationController _controller;
  late Animation<double> _animation;

  // إحداثيات المواقع (كما هي دون تغيير)
  final Map<String, Offset> _locations = {
    "Entrance": const Offset(0.5, 0.9),
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

  final Map<String, String> _stepsData = {
    "Entrance": "0",
    "Emergency Exit": "16",
    "COO Office": "13",
    "Cafeteria": "11",
    "Ms. Asmaa": "9",
    "Mr. Salah": "8",
    "Data Center": "7",
    "Maintenance": "8",
    "Lab 2": "7",
    "Boys WC": "9",
    "Girls WC": "10",
    "AI Lab": "5",
    "Lab 1": "10",
    "LAB 4": "22",
    "Lab 3": "18",
    "Staff Room": "17",
  };

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
  }

  void _updatePath(String dest) {
    setState(() {
      _selectedDestination = dest;
      _searchQuery = ""; // مسح نص البحث عند الاختيار
    });
    _controller.reset();
    _controller.forward();
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
        ? Colors.black.withOpacity(0.3)
        : Colors.white;
    final mapCanvasColor = _isDarkMode ? const Color(0xFF151515) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB6C1),
        child: const Icon(Icons.qr_code_scanner, color: Colors.black),
        onPressed: () async {
          final String? scannedRoom = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRScannerScreen()),
          );
          if (scannedRoom != null && _locations.containsKey(scannedRoom))
            _updatePath(scannedRoom);
        },
      ),
      body: Row(
        children: [
          // --- Sidebar ---
          Container(
            width: 280,
            color: sidebarColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "SCHOOL MAP",
                          style: TextStyle(
                            color: Color(0xFFFFB6C1),
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: const Color(0xFFFFB6C1),
                          ),
                          onPressed: () =>
                              setState(() => _isDarkMode = !_isDarkMode),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: (val) =>
                        setState(() => _searchQuery = val.toLowerCase()),
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "Search room...",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFFFB6C1),
                      ),
                      filled: true,
                      fillColor: _isDarkMode
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _searchQuery.isNotEmpty
                      ? _buildSearchResults(textColor) // عرض نتائج البحث
                      : ListView(
                          // عرض المجلدات الأصلية
                          children: [
                            _buildFolder(
                              Icons.school_outlined,
                              "Learning Hub",
                              ["Lab 1", "Lab 2", "Lab 3", "LAB 4", "AI Lab"],
                              textColor,
                            ),
                            _buildFolder(Icons.work_outline, "Management", [
                              "COO Office",
                              "Ms. Asmaa",
                              "Mr. Salah",
                              "Data Center",
                              "Maintenance",
                              "Staff Room",
                            ], textColor),
                            _buildFolder(Icons.wc, "W.C", [
                              "Boys WC",
                              "Girls WC",
                            ], textColor),
                            _buildFolder(Icons.more_horiz, "Others", [
                              "Entrance",
                              "Emergency Exit",
                              "Cafeteria",
                            ], textColor),
                          ],
                        ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFFFB6C1),
                  ),
                  title: const Text(
                    "Back to Main",
                    style: TextStyle(color: Colors.white54),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // --- Map Area ---
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: mapCanvasColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isDarkMode ? 0.5 : 0.05),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) => CustomPaint(
                    size: Size.infinite,
                    painter: SmartNeonPainter(
                      progress: _animation.value,
                      target: _selectedDestination.isEmpty
                          ? null
                          : _locations[_selectedDestination],
                      startNode: _locations["Entrance"]!,
                      stepCount: _stepsData[_selectedDestination] ?? "0",
                      isDarkMode: _isDarkMode,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة البحث المباشر
  Widget _buildSearchResults(Color txtColor) {
    List<String> allRooms = _locations.keys.toList();
    List<String> filteredRooms = allRooms
        .where((room) => room.toLowerCase().contains(_searchQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredRooms.length,
      itemBuilder: (context, index) {
        final room = filteredRooms[index];
        return ListTile(
          leading: const Icon(
            Icons.location_on_outlined,
            color: Color(0xFFFFB6C1),
            size: 18,
          ),
          title: Text(room, style: TextStyle(color: txtColor, fontSize: 13)),
          onTap: () => _updatePath(room),
        );
      },
    );
  }

  Widget _buildFolder(
    IconData icon,
    String title,
    List<String> items,
    Color txtColor,
  ) {
    return ExpansionTile(
      leading: Icon(icon, color: const Color(0xFFFFB6C1), size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: txtColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: items
          .map(
            (item) => ListTile(
              contentPadding: const EdgeInsets.only(left: 60),
              title: Text(
                item,
                style: TextStyle(
                  color: _selectedDestination == item
                      ? const Color(0xFFFFB6C1)
                      : txtColor.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
              onTap: () => _updatePath(item),
            ),
          )
          .toList(),
    );
  }
}

class SmartNeonPainter extends CustomPainter {
  final double progress;
  final Offset? target;
  final Offset startNode;
  final String stepCount;
  final bool isDarkMode;

  SmartNeonPainter({
    required this.progress,
    required this.target,
    required this.startNode,
    required this.stepCount,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final pinkNeon = const Color(0xFFFFB6C1);
    final corridorPaint = Paint()
      ..color = isDarkMode
          ? Colors.white.withOpacity(0.08)
          : Colors.grey.withOpacity(0.2);

    // رسم الممرات
    canvas.drawRect(
      Rect.fromLTWH(w * 0.46, h * 0.1, w * 0.08, h * 0.85),
      corridorPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.1, h * 0.42, w * 0.85, h * 0.08),
      corridorPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.1, h * 0.05, w * 0.06, h * 0.4),
      corridorPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.46, h * 0.05, w * 0.08, h * 0.1),
      corridorPaint,
    );

    _drawRooms(canvas, size);

    if (target == null) return;

    final path = Path();
    path.moveTo(startNode.dx * w, startNode.dy * h);
    path.lineTo(startNode.dx * w, 0.46 * h);
    path.lineTo(target!.dx * w, 0.46 * h);
    path.lineTo(target!.dx * w, target!.dy * h);

    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isNotEmpty) {
      final metric = pathMetrics.first;
      final currentLength = metric.length * progress;
      final currentPath = metric.extractPath(0, currentLength);

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

      final tangent = metric.getTangentForOffset(currentLength);
      if (tangent != null) {
        _drawPersonMarker(canvas, tangent.position, pinkNeon);
        _drawStepBubble(canvas, tangent.position, stepCount);
      }
    }
  }

  void _drawPersonMarker(Canvas canvas, Offset pos, Color color) {
    canvas.drawCircle(
      pos,
      15,
      Paint()
        ..color = color.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(pos, 12, Paint()..color = color);
    final tp = TextPainter(
      text: const TextSpan(text: '🚶', style: TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawStepBubble(Canvas canvas, Offset position, String steps) {
    if (steps == "0") return;
    const double bubbleW = 70, bubbleH = 30;
    final rect = Rect.fromLTWH(
      position.dx - bubbleW / 2,
      position.dy - bubbleH - 30,
      bubbleW,
      bubbleH,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()
        ..shader = ui.Gradient.linear(rect.topCenter, rect.bottomCenter, [
          const Color(0xFFFFB6C1),
          const Color(0xFFC78C9D),
        ]),
    );
    final tpSteps = TextPainter(
      text: TextSpan(
        text: "$steps steps",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpSteps.paint(
      canvas,
      Offset(
        position.dx - tpSteps.width / 2,
        rect.top + (bubbleH - tpSteps.height) / 2,
      ),
    );
  }

  void _drawRooms(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final imagePink = const Color(0xFFC78C9D);
    final imageTeal = const Color(0xFF6A9EA2);

    void drawGlassRoom(
      String label,
      double x,
      double y,
      double width,
      double height,
      Color color,
    ) {
      final rect = Rect.fromLTWH(x * w, y * h, width * w, height * h);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
      canvas.drawRRect(
        rrect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
          ).createShader(rect),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: label.toUpperCase(),
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

    drawGlassRoom("COO Office", 0.19, 0.12, 0.08, 0.06, imagePink);
    drawGlassRoom("Ms. Asmaa", 0.21, 0.35, 0.07, 0.06, imagePink);
    drawGlassRoom("Mr. Salah", 0.29, 0.35, 0.07, 0.06, imageTeal);
    drawGlassRoom("Data Center", 0.37, 0.35, 0.09, 0.06, imageTeal);
    drawGlassRoom("Boys WC", 0.68, 0.35, 0.07, 0.06, imageTeal);
    drawGlassRoom("Girls WC", 0.76, 0.35, 0.07, 0.06, imageTeal);
    drawGlassRoom("Cafeteria", 0.55, 0.22, 0.10, 0.06, imagePink);
    drawGlassRoom("Staff Room", 0.01, 0.22, 0.08, 0.06, imagePink);
    drawGlassRoom("Lab 3", 0.01, 0.12, 0.08, 0.06, imageTeal);
    drawGlassRoom("LAB 4", 0.09, 0.01, 0.1, 0.04, imageTeal);
    drawGlassRoom("EXIT", 0.45, 0.01, 0.1, 0.05, Colors.red.shade400);
    drawGlassRoom("Maintenance", 0.29, 0.51, 0.07, 0.06, imagePink);
    drawGlassRoom("Lab 2", 0.37, 0.51, 0.07, 0.06, imageTeal);
    drawGlassRoom("AI Lab", 0.72, 0.51, 0.10, 0.06, imagePink);
    drawGlassRoom("Reception", 0.44, 0.90, 0.12, 0.06, imagePink);
    drawGlassRoom("Lab 1", 0.94, 0.42, 0.05, 0.08, imageTeal);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
