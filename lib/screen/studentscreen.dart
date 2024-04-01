import 'package:attendance_monitoring/screen/home.dart';
import 'package:attendance_monitoring/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:attendance_monitoring/screen/attendancescreen.dart';
import 'package:attendance_monitoring/services/mapuse.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Future<void> scanQR() async {
    String result = "";

    try {
      result = await FlutterBarcodeScanner.scanBarcode(
        "#0000ff",
        "Cancel",
        false,
        ScanMode.QR,
      );
    } catch (e) {
      print("ERROR");
    }

    // Fetch the faculty's current location
    LatLng facultyLocation = await getFacultyCurrentLocation();

    // Verify if the student's location matches with the faculty's location
    LatLng studentLocation = await getStudentCurrentLocation();
    bool locationMatched = await isStudentWithinRange(studentLocation,
        facultyLocation, 20); // 20 meters is the maximum allowed distance

    // Navigate to AttendanceScreen if the QR scan is successful and location matches
    if (result.isNotEmpty && locationMatched) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Home(
            scanResult: result,
            title: "Attendity",
          ),
        ),
      );

      // If conditions are met, trigger the function to update metadata subcollection
      final user = await _firestoreService.getUserData();
      if (user != null && user['role'] == 0) {
        final userId = user['uid'];
        await _firestoreService.createOrUpdateMetadataSubcollection(userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance Marked succesfully'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    title: 'Attendity',
                  )),
        );
      }
    } else {
      // Show snackbar indicating unsuccessful QR scan or location mismatch
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR scan unsuccessful or location mismatched.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Attendance Report'),
        centerTitle: true,
      ),
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
