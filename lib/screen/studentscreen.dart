import 'package:attendance_monitoring/screen/attendancescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  Future<void> scanQR() async {
    String result = "";

    try {
      result = await FlutterBarcodeScanner.scanBarcode(
        "#0000ff",
        "Cancel",
        false,
        ScanMode.BARCODE,
      );
    } catch (e) {
      print("ERROR");
    }

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => AttendanceScreen(
                scanResult: result,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            scanQR();
          },
          child: Container(
            height: 80,
            width: 150,
            color: Colors.orange,
            child: const Center(
              child: Text(
                "Scan QR Code",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
