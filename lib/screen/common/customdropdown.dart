import 'package:attendance_monitoring/screen/attendance.dart';
import 'package:attendance_monitoring/screen/attendancescreen.dart';
import 'package:attendance_monitoring/screen/qrgen.dart';
import 'package:attendance_monitoring/screen/studentscreen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CustomDropdown extends StatefulWidget {
  final String title;
  final List<String> options;

  const CustomDropdown({
    Key? key,
    required this.title,
    required this.options,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool isExpanded = false;
  late String selectedOption;
  late List<String> _randomTimes;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options[0];
    _generateRandomTimes();
  }

  void _generateRandomTimes() {
    _randomTimes = [];
    final Random random = Random();
    Set<int> generatedHours =
        Set<int>(); // Track generated hours to ensure uniqueness
    for (int i = 0; i < widget.options.length; i++) {
      int hour;
      int minute = 0; // Start with 0 minutes for simplicity

      // Generate a unique hour
      do {
        hour = 9 + random.nextInt(6); // Random hour between 9 and 14 (2 PM)
      } while (generatedHours.contains(hour));

      // Add the generated hour to the set
      generatedHours.add(hour);

      // Convert hour to 12-hour format and determine AM/PM
      String time;
      if (hour < 12) {
        time = '$hour:${minute.toString().padLeft(2, '0')} AM';
      } else if (hour == 12) {
        time = '$hour:${minute.toString().padLeft(2, '0')} PM';
      } else {
        time = '${hour - 12}:${minute.toString().padLeft(2, '0')} PM';
      }

      _randomTimes.add(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        GestureDetector(
          onTap: () {
            if (widget.title == "Today's Classes" ||
                widget.title == "Class Attendance") {
              setState(() {
                isExpanded = !isExpanded;
              });
            } else {
              _navigateToScreen(context);
            }
          },
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Spacer(),
                Icon(isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Column(
            children: [
              // Dropdown options with random times
              for (int i = 0; i < widget.options.length; i++)
                ListTile(
                  title: Text('${widget.options[i]} - ${_randomTimes[i]}'),
                  onTap: () {
                    setState(() {
                      selectedOption = widget.options[i];
                      isExpanded = false;
                    });
                    if (widget.title == "Class Attendance") {
                      // Navigate to QR generation screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRGenerationScreen(
                              selectedOption: selectedOption),
                        ),
                      );
                    }
                  },
                ),
              Divider(), // Add a divider after each dropdown
            ],
          ),
      ],
    );
  }

  // Function to navigate to respective screens based on selected option
  void _navigateToScreen(BuildContext context) {
    switch (widget.title) {
      case 'Class Attendance Report':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentScreen()),
        );
        break;
      case 'Faculty Details':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FacultyAttendanceScreen()),
        );
        break;
      case 'Class Details':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FacultyAttendanceScreen()),
        );
        break;
      case 'Lost and found':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FacultyAttendanceScreen()),
        );
        break;
    }
  }
}
