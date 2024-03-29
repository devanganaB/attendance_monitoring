import 'package:attendance_monitoring/screen/chat.dart';
import 'package:attendance_monitoring/screen/common/customdropdown.dart';
import 'package:attendance_monitoring/screen/drawer.dart';
import 'package:attendance_monitoring/services/auth.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

final today = DateTime.now();

class FHome extends StatefulWidget {
  const FHome({super.key});

  @override
  State<FHome> createState() => _FHomeState();
}

class _FHomeState extends State<FHome> {
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Fetch user data from Firestore using AuthService
      final user = await AuthService().getCurrentUser();
      if (user != null) {
        final userData = await AuthService.getUserData(user.uid);
        if (userData != null) {
          setState(() {
            _userName = userData['name'] ?? '';
            _userEmail = userData['email'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  List<DateTime?> _dialogCalendarPickerValue = [
    today,
    today.add(Duration(days: 4)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Addendity"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _openCalendarDialog();
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(_userName.isNotEmpty
                          ? _userName.substring(0, 1).toUpperCase()
                          : 'S'), // Replace with user's initials
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        Text(_userEmail),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Text section
              Text(
                'Hi, $_userName.',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              Text(
                'Welcome to your Class',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[300]),
              ),

              // Buttons and functionalities section
              SizedBox(height: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomDropdown(
                    title: "Today's Classes",
                    options: ['D12C', 'D7A', 'D17B', 'D11AD'],
                  ),
                  CustomDropdown(
                    title: 'Class Attendance',
                    options: ['D12C', 'D7A', 'D17B', 'D11AD'],
                  ),
                  CustomDropdown(
                    title: 'Faculty Details',
                    options: ['Faculty 1', 'Faculty 2', 'Faculty 3'],
                  ),
                  CustomDropdown(
                    title: 'Class Details',
                    options: [
                      'Class detail 1',
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Set initial selected index (optional)
        selectedItemColor: Colors.blue[600], // Customize selected item color
        onTap: (int index) {
          switch (index) {
            case 0:
              // Handle Home button press (usually no action needed)
              break;
            case 1:
              // Navigate to Chat screen
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Chat()));
              break;
            case 2:
              // Handle Profile button press (navigate to profile screen if needed)
              break;
          }
        },
      ),
    );
  }

  // Function to open the calendar dialog
  void _openCalendarDialog() async {
    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: _getCalendarConfig(), // Function to get calendar config
      dialogSize: const Size(300, 400),
      borderRadius: BorderRadius.circular(15),
      value: _dialogCalendarPickerValue,
      dialogBackgroundColor: Colors.white,
    );
    if (values != null) {
      setState(() {
        _dialogCalendarPickerValue = values;
      });
    }
  }

  // Function to get calendar config
  CalendarDatePicker2WithActionButtonsConfig _getCalendarConfig() {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: const TextStyle(color: Colors.white),
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
