import 'package:attendance_monitoring/screen/common/calendar.dart';
import 'package:attendance_monitoring/screen/common/customdropdown.dart';
import 'package:attendance_monitoring/screen/drawer.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

final today = DateTime.now();

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DateTime?> _dialogCalendarPickerValue = [
    today,
    today.add(Duration(days: 4)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                padding: EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text('S'), // Replace with user's initials
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sakshi Choudhary',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        Text('sakshichoudhary@email.com'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Text section
              Text(
                'Hi, Sakshi.',
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
                    options: ['Physics', 'Chemistry', 'Mathematics I', 'Java'],
                  ),
                  CustomDropdown(
                    title: 'Class Attendance Report',
                    options: ['one'],
                  ),
                  CustomDropdown(
                    title: 'Faculty Details',
                    options: ['Faculty 1', 'Faculty 2', 'Faculty 3'],
                  ),
                  CustomDropdown(
                    title: 'Class Details',
                    options: [
                      'Class detail 1',
                      'Class detail 2',
                      'Class detail 3'
                    ],
                  ),
                  CustomDropdown(
                    title: 'Lost and found',
                    options: ['Lost', 'Found'],
                  ),
                ],
              ),
            ],
          ),
        ),
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
