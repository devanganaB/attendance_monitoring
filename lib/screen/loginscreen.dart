import 'package:attendance_monitoring/colors/pallete.dart';
import 'package:attendance_monitoring/screen/home.dart';
import 'package:attendance_monitoring/screen/phoneauth.dart';
import 'package:attendance_monitoring/screen/register.dart';
import 'package:attendance_monitoring/screen/studentscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User logged in: ${userCredential.user!.email}");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(title: 'Classroom')
              .animate()
              .slideX(delay: Duration(milliseconds: 8))));
      // Navigate to the next screen or perform desired actions upon successful login.
    } catch (e) {
      print("Login failed: $e");
      // Handle login failure, display error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/login.jpg',
                  fit: BoxFit.contain,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Student ID',
                      hintText: 'Enter your student ID',
                      icon: Icon(Icons.email),
                      iconColor: Pallete.primary),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      icon: Icon(Icons.pin),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Pallete.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      iconColor: Pallete.primary),
                ),
                GestureDetector(
                  onTap: _login,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneAuth()
                            .animate()
                            .slideX(delay: Duration(milliseconds: 8)),
                      ),
                    );
                  },
                  child: Text("Login with Phone"),
                ),
                SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a user yet? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register()
                                  .animate()
                                  .slideX(delay: Duration(milliseconds: 8)),
                            ),
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginInfo {
  static String id = ' ';
}
