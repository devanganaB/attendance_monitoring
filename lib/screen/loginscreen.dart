import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: idController,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
              ),
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

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const StudentScreen()),
                        // );
                      }
                    }
                  }
                },
                child: Container(
                  height: 80,
                  width: 150,
                  color: Colors.orange,
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
