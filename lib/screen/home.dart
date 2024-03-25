import 'package:attendance_monitoring/screen/common/customdropdown.dart';
import 'package:attendance_monitoring/screen/drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Padding(
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
                  options: ['Physics', 'Chemistry', 'Mathematics I'],
                ),
                CustomDropdown(
                  title: 'Class Attendance Report',
                  options: ['one', 'two'],
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
    );
  }
}
