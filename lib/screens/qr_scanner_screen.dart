import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isScanned = false; // لمنع التكرار

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan Room QR",
          style: TextStyle(
            color: Color(0xFFFFB6C1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFFFB6C1)),
      ),
      backgroundColor: Colors.black,
      body: MobileScanner(
        onDetect: (capture) {
          if (isScanned) return; // لو لقط مرة ميكملش

          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              setState(() => isScanned = true); // اقفل السكنر
              final String code = barcode.rawValue!;
              Navigator.pop(context, code);
              break;
            }
          }
        },
      ),
    );
  }
}
