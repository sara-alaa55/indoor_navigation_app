import 'package:flutter/material.dart';

void main() => runApp(const SchoolNavApp());

class SchoolNavApp extends StatelessWidget {
  const SchoolNavApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFFB6C1),
      ),
      home: const NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key}); // تم تصحيح super.shared لـ super.key
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  String _selectedDestination = "";
  String _searchQuery = "";
  int _currentFloor = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  // القائمة الكاملة للدور الأرضي
  final List<Map<String, dynamic>> _groundData = [
    {
      "name": "Reception",
      "pos": const Offset(0.3, 0.98),
      "type": "Other",
      "floor": 0,
    },
    {
      "name": "Manager Office",
      "pos": const Offset(0.42, 0.90),
      "type": "Offices",
      "floor": 0,
    },
    {
      "name": "Lab 5",
      "pos": const Offset(0.42, 0.84),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "A1",
      "pos": const Offset(0.42, 0.72),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "A2",
      "pos": const Offset(0.42, 0.66),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "Girls WC",
      "pos": const Offset(0.42, 0.60),
      "type": "W.C",
      "floor": 0,
    },
    {
      "name": "A3",
      "pos": const Offset(0.42, 0.54),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "A4 / Lab 6",
      "pos": const Offset(0.42, 0.48),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "Boys WC",
      "pos": const Offset(0.42, 0.42),
      "type": "W.C",
      "floor": 0,
    },
    {
      "name": "Mr. Mohamed",
      "pos": const Offset(0.42, 0.36),
      "type": "Offices",
      "floor": 0,
    },
    {
      "name": "A5",
      "pos": const Offset(0.42, 0.30),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "A6",
      "pos": const Offset(0.42, 0.24),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "Store 1",
      "pos": const Offset(0.42, 0.18),
      "type": "Stores",
      "floor": 0,
    },
    {
      "name": "A7",
      "pos": const Offset(0.42, 0.12),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "Store 2",
      "pos": const Offset(0.42, 0.06),
      "type": "Stores",
      "floor": 0,
    },
    {
      "name": "Control Room",
      "pos": const Offset(0.42, 0.0),
      "type": "Offices",
      "floor": 0,
    },
    {
      "name": "Cafeteria",
      "pos": const Offset(0.18, 0.0),
      "type": "Other",
      "floor": 0,
    },
    {
      "name": "Hall 9 / Lab 8",
      "pos": const Offset(0.3, -0.35),
      "type": "Halls & Labs",
      "floor": 0,
    },
    {
      "name": "Hall 8 / Lab 7",
      "pos": const Offset(0.58, -0.15),
      "type": "Halls & Labs",
      "floor": 0,
    },
  ];

  // القائمة الكاملة للدور الأول
  final List<Map<String, dynamic>> _firstData = [
    {
      "name": "Hall 11",
      "pos": const Offset(0.75, 0.45),
      "type": "Halls & Labs",
      "floor": 1,
    },
    {
      "name": "Mr. Abdelrahman",
      "pos": const Offset(0.75, 0.25),
      "type": "Offices",
      "floor": 1,
    },
    {
      "name": "Hall 9",
      "pos": const Offset(0.06, 0.65),
      "type": "Halls & Labs",
      "floor": 1,
    },
    {
      "name": "Hall 10",
      "pos": const Offset(0.15, 0.90),
      "type": "Halls & Labs",
      "floor": 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _changeFloor(int floor) {
    setState(() {
      _currentFloor = floor;
      _selectedDestination = "";
    });
    _controller.reset();
  }

  void _updatePath(Map<String, dynamic> item) {
    if (item['floor'] != _currentFloor) {
      setState(() => _currentFloor = item['floor']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Moving to ${item['floor'] == 0 ? 'Ground' : '1st'} Floor for ${item['name']}",
          ),
          backgroundColor: const Color(0xFFFFB6C1),
        ),
      );
    }
    setState(() => _selectedDestination = item['name']);
    _controller.reset();
    _controller.forward();
  }

  Widget _buildExpansionCategory(
    String title,
    IconData icon,
    List<String> types,
  ) {
    final allItems = [..._groundData, ..._firstData]
        .where(
          (e) =>
              types.contains(e['type']) &&
              e['name'] != "Reception" &&
              e['name'].toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    if (allItems.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      initiallyExpanded: _searchQuery.isNotEmpty,
      leading: Icon(icon, size: 18, color: const Color(0xFFFFB6C1)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      children: allItems
          .map(
            (item) => ListTile(
              contentPadding: const EdgeInsets.only(left: 40, right: 10),
              dense: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['name'], style: const TextStyle(fontSize: 10)),
                  if (item['floor'] == 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "1st Fl",
                        style: TextStyle(fontSize: 7, color: Colors.blue),
                      ),
                    ),
                ],
              ),
              selected: _selectedDestination == item['name'],
              onTap: () => _updatePath(item),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMapData = _currentFloor == 0 ? _groundData : _firstData;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "SCHOOL MAP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFB6C1),
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: "Search for a room...",
                      hintStyle: const TextStyle(fontSize: 12),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: Color(0xFFFFB6C1),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: _currentFloor == 0
                                  ? const Color(0xFFFFB6C1)
                                  : Colors.transparent,
                            ),
                            onPressed: () => _changeFloor(0),
                            child: Text(
                              "Ground",
                              style: TextStyle(
                                color: _currentFloor == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: _currentFloor == 1
                                  ? const Color(0xFFFFB6C1)
                                  : Colors.transparent,
                            ),
                            onPressed: () => _changeFloor(1),
                            child: Text(
                              "1st Floor",
                              style: TextStyle(
                                color: _currentFloor == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildExpansionCategory("Halls & Labs", Icons.school, [
                        "Halls & Labs",
                      ]),
                      _buildExpansionCategory("Offices", Icons.work, [
                        "Offices",
                      ]),
                      _buildExpansionCategory("W.C", Icons.wc, ["W.C"]),
                      _buildExpansionCategory("Others", Icons.more_horiz, [
                        "Other",
                        "Stores",
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => CustomPaint(
                size: Size.infinite,
                painter: MapPainter(
                  progress: _animation.value,
                  floor: _currentFloor,
                  target: _selectedDestination.isEmpty
                      ? null
                      : _findTargetPos(),
                  rooms: currentMapData,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // فنكشن صغيرة عشان تلاقي إحداثيات القاعة حتى لو في دور تاني
  Offset? _findTargetPos() {
    try {
      final all = [..._groundData, ..._firstData];
      return all.firstWhere((e) => e['name'] == _selectedDestination)['pos'];
    } catch (e) {
      return null;
    }
  }
}

class MapPainter extends CustomPainter {
  final double progress;
  final int floor;
  final Offset? target;
  final List<Map<String, dynamic>> rooms;

  MapPainter({
    required this.progress,
    required this.floor,
    this.target,
    required this.rooms,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.translate(0, h * 0.25);
    final hAdj = h * 0.7;
    final pink = const Color(0xFFFFB6C1);
    final corridorPaint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (floor == 1) {
      final path = Path();
      path.moveTo(w * 0.5, hAdj * 0.95);
      path.lineTo(w * 0.5, hAdj * 0.35);
      path.moveTo(w * 0.15, hAdj * 0.35);
      path.lineTo(w * 0.85, hAdj * 0.35);
      path.moveTo(w * 0.15, hAdj * 0.35);
      path.lineTo(w * 0.15, hAdj * 0.95);
      canvas.drawPath(path, corridorPaint..strokeWidth = w * 0.1);
    } else {
      final mainPath = Path();
      mainPath.moveTo(w * 0.3, hAdj * 0.98);
      mainPath.lineTo(w * 0.3, hAdj * -0.4);
      canvas.drawPath(mainPath, corridorPaint..strokeWidth = w * 0.1);
      final sidePath = Path();
      sidePath.moveTo(w * 0.3, hAdj * -0.15);
      sidePath.lineTo(w * 0.55, hAdj * -0.15);
      canvas.drawPath(sidePath, corridorPaint..strokeWidth = w * 0.05);
    }

    for (var room in rooms) {
      double rW = w * 0.14;
      double rH = hAdj * 0.05;
      if (room['name'].contains("Hall")) rW = w * 0.18;
      _drawRoom(
        canvas,
        room['name'],
        room['pos'].dx * w - (rW / 2),
        room['pos'].dy * hAdj - (rH / 2),
        rW,
        rH,
        pink,
      );
    }

    if (target != null) {
      final navPath = Path();
      if (floor == 1) {
        navPath.moveTo(w * 0.5, hAdj * 0.95);
        navPath.lineTo(w * 0.5, hAdj * 0.35);
        if (target!.dx > 0.4) {
          navPath.lineTo(target!.dx * w, hAdj * 0.35);
        } else {
          navPath.lineTo(w * 0.15, hAdj * 0.35);
          navPath.lineTo(w * 0.15, target!.dy * hAdj);
        }
        navPath.lineTo(target!.dx * w, target!.dy * hAdj);
      } else {
        navPath.moveTo(w * 0.3, hAdj * 0.98);
        navPath.lineTo(w * 0.3, target!.dy * hAdj);
        navPath.lineTo(target!.dx * w, target!.dy * hAdj);
      }
      final metrics = navPath.computeMetrics().toList();
      if (metrics.isNotEmpty) {
        final metric = metrics.first;
        canvas.drawPath(
          metric.extractPath(0, metric.length * progress),
          Paint()
            ..color = pink
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  void _drawRoom(
    Canvas canvas,
    String label,
    double x,
    double y,
    double width,
    double height,
    Color color,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, width, height),
        const Radius.circular(4),
      ),
      Paint()..color = color,
    );
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 7,
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
