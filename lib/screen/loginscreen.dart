import 'package:attendance_monitoring/screen/phoneauth.dart';
import 'package:attendance_monitoring/screen/register.dart';
import 'package:attendance_monitoring/screen/studentscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/login.jpg',
                fit: BoxFit.contain,
              ),
              TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    hintText: 'Enter your student ID',
                  )),
              TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  )),
              GestureDetector(
                onTap: () async {
                  String id = idController.text.toString();
                  String pass = passwordController.text.toString();

                  if (id.isNotEmpty) {
                    if (pass.isNotEmpty) {
                      DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection("Employee")
                          .doc(id.toUpperCase())
                          .get();

                      String password = snap['password'];

                      if (pass == password) {
                        setState(() {
                          LoginInfo.id = id.toUpperCase();
                        });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentScreen()),
                        );
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneAuth()
                                .animate()
                                .slideX(delay: Duration(milliseconds: 8))));
                  },
                  child: Text("Login with Phone")),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not an user yet? "),
                    GestureDetector(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()
                                      .animate()
                                      .slideX(
                                          delay: Duration(milliseconds: 8))));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginInfo {
  static String id = ' ';
}
