import 'package:flutter/material.dart';

class FacultyAttendanceScreen extends StatefulWidget {
  const FacultyAttendanceScreen({super.key});

  @override
  State<FacultyAttendanceScreen> createState() =>
      _FacultyAttendanceScreenState();
}

class _FacultyAttendanceScreenState extends State<FacultyAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Attendance Report'),
        centerTitle: true,
      ),
      body: Center(child: Text('new screen')),
    );
  }
}
