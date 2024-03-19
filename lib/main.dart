import 'dart:async';

import 'package:attendance_monitoring/firebase_options.dart';
import 'package:attendance_monitoring/screen/home.dart';
import 'package:attendance_monitoring/screen/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Classroom Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
        ),
        home: splashScreen()
        // const LoginScreen(),
        );
  }
}

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Text(
              'Attendity',
              style: TextStyle(fontSize: 40),
            )
                .animate()
                .fadeIn(duration: Duration(milliseconds: 500))
                .slide()
                .tint(color: Colors.lightBlue),
          ),
          Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/classroom.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                  color: Colors.orange,
                )),
          )
        ],
      ),
    );
  }
}
