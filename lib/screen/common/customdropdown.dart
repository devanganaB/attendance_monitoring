import 'package:attendance_monitoring/screen/attendance.dart';
import 'package:attendance_monitoring/screen/attendancescreen.dart';
import 'package:attendance_monitoring/screen/studentscreen.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        GestureDetector(
          onTap: () {
            if (widget.title == "Today's Classes") {
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
              // Dropdown options
              for (String option in widget.options)
                ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      selectedOption = option;
                      isExpanded = false;
                    });
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
          MaterialPageRoute(builder: (context) => ClassAttendanceScreen()),
        );
        break;
      case 'Class Details':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassAttendanceScreen()),
        );
        break;
      case 'Lost and found':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassAttendanceScreen()),
        );
        break;
    }
  }
}
