import 'package:attendance_monitoring/services/mapuse.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class QRGenerationScreen extends StatefulWidget {
  final String selectedOption;

  const QRGenerationScreen({Key? key, required this.selectedOption})
      : super(key: key);

  @override
  State<QRGenerationScreen> createState() => _QRGenerationScreenState();
}

class _QRGenerationScreenState extends State<QRGenerationScreen> {
  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission granted, proceed with getting location
      return;
    } else {
      // Location permission denied, handle accordingly
      throw Exception('Location permission denied');
    }
  }

  bool _qrGenerated = false; // Flag to track whether QR is generated or not
  late LatLng _facultyLocation; // Faculty location
  late Timer _timer;
  int _countdown = 60; // Initial countdown value

  @override
  void initState() {
    super.initState();
    // _startCountdownTimer();
    _generateQRCode();
  }

  void _generateQRCode() async {
    try {
      final location = await getFacultyCurrentLocation();
      setState(() {
        _facultyLocation = location;
        _qrGenerated = true; // Set flag to true once QR is generated
      });
      // Automatically navigate back to FHome after 60 seconds
      Future.delayed(Duration(seconds: 60), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      print('Error generating QR code: $e');
    }
  }

  // void _startCountdownTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (_countdown > 0) {
  //       setState(() {
  //         _countdown--;
  //       });
  //     } else {
  //       _timer.cancel(); // Cancel the timer when countdown reaches 0
  //       Navigator.of(context).pop(); // Navigate back to FHome
  //     }
  //   });
  // }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<void>(
          future:
              requestLocationPermission(), // Request location permission first
          builder: (context, permissionSnapshot) {
            if (permissionSnapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator while requesting permission
              return CircularProgressIndicator();
            } else if (permissionSnapshot.hasError) {
              // Show error message if permission request fails
              return Text('Error: ${permissionSnapshot.error}');
            } else {
              // Once permission is granted, check if QR is generated
              if (_qrGenerated) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: 'Class: ${widget.selectedOption}\n'
                          'Timestamp: ${DateTime.now()}\n'
                          'FacultyEmail: sakshichoudhary@email.com\n'
                          'FacultyLocation: ${_facultyLocation.latitude}, ${_facultyLocation.longitude}',
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                    ),
                    const SizedBox(height: 20.0), // Display the encoded data
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }
          },
        ),
      ),
    );
  }
}
