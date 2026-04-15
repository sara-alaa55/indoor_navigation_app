import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'qr_scanner_screen.dart';

class TheoryScreen extends StatefulWidget {
  const TheoryScreen({super.key});

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen>
    with TickerProviderStateMixin {
  String _selectedDestination = "";
  int _currentFloor = 0;
  String _startPoint = "Reception";
  bool _isDarkMode = true;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  // --- الداتا الخاصة بالأدوار ---
  final List<Map<String, dynamic>> _groundData = [
    {"name": "Reception", "pos": const Offset(0.3, 0.98), "type": "Other"},
    {
      "name": "Manager Office",
      "pos": const Offset(0.42, 0.90),
      "type": "Offices",
    },
    {"name": "Lab 5", "pos": const Offset(0.42, 0.84), "type": "Halls & Labs"},
    {"name": "A1", "pos": const Offset(0.42, 0.72), "type": "Halls & Labs"},
    {"name": "A2", "pos": const Offset(0.42, 0.66), "type": "Halls & Labs"},
    {"name": "Girls WC", "pos": const Offset(0.42, 0.60), "type": "W.C"},
    {"name": "A3", "pos": const Offset(0.42, 0.54), "type": "Halls & Labs"},
    {
      "name": "A4 / Lab 6",
      "pos": const Offset(0.42, 0.48),
      "type": "Halls & Labs",
    },
    {"name": "Boys WC", "pos": const Offset(0.42, 0.42), "type": "W.C"},
    {"name": "Mr. Mohamed", "pos": const Offset(0.42, 0.36), "type": "Offices"},
    {"name": "A5", "pos": const Offset(0.42, 0.30), "type": "Halls & Labs"},
    {"name": "A6", "pos": const Offset(0.42, 0.24), "type": "Halls & Labs"},
    {"name": "Store 1", "pos": const Offset(0.42, 0.18), "type": "Stores"},
    {"name": "A7", "pos": const Offset(0.42, 0.12), "type": "Halls & Labs"},
    {"name": "Store 2", "pos": const Offset(0.42, 0.06), "type": "Stores"},
    {"name": "Control Room", "pos": const Offset(0.42, 0.0), "type": "Offices"},
    {"name": "Cafeteria", "pos": const Offset(0.18, 0.0), "type": "Other"},
    {
      "name": "Hall 9 / Lab 8",
      "pos": const Offset(0.3, -0.35),
      "type": "Halls & Labs",
    },
    {
      "name": "Hall 8 / Lab 7",
      "pos": const Offset(0.58, -0.15),
      "type": "Halls & Labs",
    },
  ];

  final List<Map<String, dynamic>> _firstData = [
    {
      "name": "Hall 11",
      "pos": const Offset(0.75, 0.45),
      "type": "Halls & Labs",
    },
    {
      "name": "Mr. Abdelrahman",
      "pos": const Offset(0.75, 0.25),
      "type": "Offices",
    },
    {"name": "Hall 9", "pos": const Offset(0.06, 0.65), "type": "Halls & Labs"},
    {
      "name": "Hall 10",
      "pos": const Offset(0.15, 0.90),
      "type": "Halls & Labs",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updatePath(String dest, int floorOfDest) {
    setState(() {
      if (_currentFloor != floorOfDest) _currentFloor = floorOfDest;
      _selectedDestination = dest;
      _searchQuery = "";
      _searchController.clear();
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final sidebarColor = _isDarkMode
        ? Colors.black.withOpacity(0.3)
        : Colors.white;

    Offset? getPosByName(String name) {
      if (_groundData.any((e) => e['name'] == name))
        return _groundData.firstWhere((e) => e['name'] == name)['pos'];
      if (_firstData.any((e) => e['name'] == name))
        return _firstData.firstWhere((e) => e['name'] == name)['pos'];
      return null;
    }

    // تجهيز نتائج البحث مع تحديد الدور
    List<Map<String, dynamic>> searchResults = [];
    if (_searchQuery.isNotEmpty) {
      searchResults.addAll(
        _groundData
            .where((e) => e['name'].toLowerCase().contains(_searchQuery))
            .map((e) => {...e, "floor": 0}),
      );
      searchResults.addAll(
        _firstData
            .where((e) => e['name'].toLowerCase().contains(_searchQuery))
            .map((e) => {...e, "floor": 1}),
      );
    }

    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[200],
      body: Row(
        children: [
          // --- Sidebar ---
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: sidebarColor,
              border: Border(
                right: BorderSide(
                  color: _isDarkMode ? Colors.white10 : Colors.black12,
                ),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "THEORY",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFFB6C1),
                          fontSize: 18,
                          letterSpacing: 1.2,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            setState(() => _isDarkMode = !_isDarkMode),
                        icon: Icon(
                          _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: const Color(0xFFFFB6C1),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) =>
                        setState(() => _searchQuery = val.toLowerCase()),
                    style: TextStyle(color: textColor, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Search room...",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFFFB6C1),
                        size: 18,
                      ),
                      filled: true,
                      fillColor: _isDarkMode
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _searchQuery.isNotEmpty
                      ? ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final item = searchResults[index];
                            final bool isFirst = item['floor'] == 1;
                            return ListTile(
                              title: Text(
                                item['name'],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13,
                                ),
                              ),
                              subtitle: Text(
                                isFirst ? "1st Floor" : "Ground Floor",
                                style: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                  fontSize: 10,
                                ),
                              ),
                              trailing: Icon(
                                isFirst
                                    ? Icons.layers
                                    : Icons.location_on_outlined,
                                size: 14,
                                color: const Color(0xFFFFB6C1),
                              ),
                              onTap: () =>
                                  _updatePath(item['name'], item['floor']),
                            );
                          },
                        )
                      : ListView(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.qr_code_scanner,
                                color: Color(0xFFFFB6C1),
                              ),
                              title: Text(
                                "Scan My Location",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Current: $_startPoint",
                                style: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                  fontSize: 10,
                                ),
                              ),
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const QRScannerScreen(),
                                  ),
                                );
                                if (result != null)
                                  setState(() => _startPoint = result);
                              },
                            ),
                            const Divider(color: Colors.white10),
                            _buildCombinedCategory(
                              "Halls & Labs",
                              Icons.school,
                              ["Halls & Labs"],
                            ),
                            _buildCombinedCategory("Offices", Icons.work, [
                              "Offices",
                            ]),
                            _buildCombinedCategory("W.C", Icons.wc, ["W.C"]),
                          ],
                        ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFFFB6C1),
                  ),
                  title: Text("Back", style: TextStyle(color: textColor)),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // --- Map Area ---
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF151515) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isDarkMode ? 0.4 : 0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) => CustomPaint(
                    size: Size.infinite,
                    painter: MapPainter(
                      progress: _animation.value,
                      floor: _currentFloor,
                      selectedName: _selectedDestination,
                      startPos: getPosByName(_startPoint),
                      target: _selectedDestination.isEmpty
                          ? null
                          : getPosByName(_selectedDestination),
                      rooms: _currentFloor == 0 ? _groundData : _firstData,
                      isDark: _isDarkMode,
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

  Widget _buildCombinedCategory(
    String title,
    IconData icon,
    List<String> types,
  ) {
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final groundItems = _groundData
        .where((e) => types.contains(e['type']) && e['name'] != "Reception")
        .toList();
    final firstItems = _firstData
        .where((e) => types.contains(e['type']))
        .toList();

    return ExpansionTile(
      leading: Icon(icon, color: const Color(0xFFFFB6C1), size: 20),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        ...groundItems.map(
          (item) => ListTile(
            title: Text(
              item['name'],
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
            ),
            onTap: () => _updatePath(item['name'], 0),
          ),
        ),
        ...firstItems.map(
          (item) => ListTile(
            title: Text(
              "${item['name']} (1st Floor)",
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
            ),
            onTap: () => _updatePath(item['name'], 1),
          ),
        ),
      ],
    );
  }
}

class MapPainter extends CustomPainter {
  final double progress;
  final int floor;
  final Offset? target;
  final Offset? startPos;
  final String selectedName;
  final List<Map<String, dynamic>> rooms;
  final bool isDark;

  MapPainter({
    required this.progress,
    required this.floor,
    this.target,
    this.startPos,
    required this.selectedName,
    required this.rooms,
    required this.isDark,
  });

  int _getSteps(String name) {
    final stepsMap = {
      "Manager Office": 39,
      "Lab 5": 43,
      "A1": 45,
      "A2": 53,
      "Girls WC": 60,
      "A3": 63,
      "A4 / Lab 6": 62,
      "Boys WC": 75,
      "Mr. Mohamed": 79,
      "A5": 85,
      "A6": 86,
      "Store 1": 92,
      "A7": 93,
      "Store 2": 94,
      "Control Room": 99,
      "Hall 8 / Lab 7": 103,
      "Hall 9 / Lab 8": 109,
      "Hall 9": 83,
      "Hall 10": 84,
      "Mr. Abdelrahman": 82,
      "Hall 11": 84,
    };
    return stepsMap[name] ?? 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.translate(0, h * 0.25);
    final hAdj = h * 0.7;
    const pinkAccent = Color(0xFFFFB6C1);

    final corridorPaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.03)
          : Colors.black.withOpacity(0.03);

    // ممرات الأدوار
    if (floor == 1) {
      final path = Path();
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.45, hAdj * 0.35, w * 0.1, hAdj * 0.6),
          const Radius.circular(20),
        ),
      );
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.1, hAdj * 0.3, w * 0.8, hAdj * 0.1),
          const Radius.circular(20),
        ),
      );
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.1, hAdj * 0.3, w * 0.1, hAdj * 0.65),
          const Radius.circular(20),
        ),
      );
      canvas.drawPath(path, corridorPaint);
    } else {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.25, hAdj * -0.4, w * 0.1, hAdj * 1.4),
        corridorPaint,
      );
    }

    // رسم الغرف بتصميم زجاجي
    for (var room in rooms) {
      double rW = w * 0.16, rH = hAdj * 0.055;
      if (room['name'].contains("Hall")) rW = w * 0.20;
      Color roomColor = (room['type'] == "Halls & Labs")
          ? const Color(0xFF6A9EA2)
          : const Color(0xFFC78C9D);
      _drawGlassRoom(
        canvas,
        room['name'],
        room['pos'].dx * w - (rW / 2),
        room['pos'].dy * hAdj - (rH / 2),
        rW,
        rH,
        roomColor,
      );
    }

    // منطق الملاحة والمسار
    if (target != null && startPos != null) {
      final navPath = Path();
      navPath.moveTo(startPos!.dx * w, startPos!.dy * hAdj);

      // التوقف عند باب الغرفة في الممر
      double stopAtEdgeX = target!.dx > 0.35 ? w * 0.35 : w * 0.25;

      if (floor == 1) {
        navPath.lineTo(w * 0.5, hAdj * 0.35);
        if (target!.dx > 0.4)
          navPath.lineTo(stopAtEdgeX, hAdj * 0.35);
        else {
          navPath.lineTo(w * 0.15, hAdj * 0.35);
          navPath.lineTo(w * 0.15, target!.dy * hAdj);
        }
      } else {
        navPath.lineTo(w * 0.3, startPos!.dy * hAdj);
        navPath.lineTo(w * 0.3, target!.dy * hAdj);
        navPath.lineTo(stopAtEdgeX, target!.dy * hAdj);
      }

      final metric = navPath.computeMetrics().first;
      final currentLen = metric.length * progress;
      final pathSub = metric.extractPath(0, currentLen);

      // تأثير التوهج للمسار (Glow)
      canvas.drawPath(
        pathSub,
        Paint()
          ..color = pinkAccent.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // المسار الأساسي
      canvas.drawPath(
        pathSub,
        Paint()
          ..color = pinkAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round,
      );

      final tangent = metric.getTangentForOffset(currentLen);
      if (tangent != null) {
        _drawPersonMarker(canvas, tangent.position, pinkAccent);
        _drawStepBubble(
          canvas,
          tangent.position,
          (_getSteps(selectedName) * progress).toInt(),
        );
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

  void _drawStepBubble(Canvas canvas, Offset position, int steps) {
    const double bW = 60, bH = 32;
    final rect = Rect.fromLTWH(
      position.dx - bW / 2,
      position.dy - bH - 25,
      bW,
      bH,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()
        ..shader = ui.Gradient.linear(rect.topCenter, rect.bottomCenter, [
          const Color(0xFFFFB6C1),
          const Color(0xFFC78C9D),
        ]),
    );
    final tp = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$steps ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const TextSpan(
            text: "steps",
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(position.dx - tp.width / 2, rect.top + (bH - tp.height) / 2),
    );
  }

  void _drawGlassRoom(
    Canvas canvas,
    String label,
    double x,
    double y,
    double width,
    double height,
    Color color,
  ) {
    final rect = Rect.fromLTWH(x, y, width, height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(
      rrect.shift(const Offset(2, 3)),
      Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = LinearGradient(
          colors: [color.withOpacity(0.85), color.withOpacity(0.4)],
        ).createShader(rect),
    );
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    tp.paint(
      canvas,
      Offset(x + (width - tp.width) / 2, y + (height - tp.height) / 2),
    );
  }

  @override
  bool shouldRepaint(MapPainter oldDelegate) => true;
}
