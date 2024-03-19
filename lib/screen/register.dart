import 'package:attendance_monitoring/colors/pallete.dart';
import 'package:attendance_monitoring/screen/home.dart';
import 'package:attendance_monitoring/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  // TextEditingController _divisionController = TextEditingController();
  TextEditingController _rollNumberController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = false;
  int role = 0; // 0 for Student, 1 for Faculty

  // Dummy photo for biometric verification
  String photoUrl = ''; // Provide the URL or path of the photo here
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to register the user
  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': _emailController.text,
        'name': '${_firstNameController.text} ${_lastNameController.text}',
        'roll': _rollNumberController.text,
        // 'division': _divisionController.text,
        'class': _classController.text,
        'contact': _contactNumberController.text,
        'address': _addressController.text,
        'role': role,
      });
      print("User registered: ${userCredential.user!.email}");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Home(title: "Classroom")));
    } catch (e) {
      print("Registration failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dummy section for photo (replace with your photo selection widget)
              // Container(
              //   height: 200,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Center(
              //     child: Text('Photo for Biometric Verification'),
              //   ),
              // ),
              // SizedBox(height: 16),
              // Individual TextFormFields inside Containers with border radius 30
              Center(
                child: ToggleSwitch(
                  minWidth: 90.0,
                  initialLabelIndex: 1,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: ['Student', 'Faculty'],
                  activeBgColors: [
                    [Pallete.bgprimary],
                    [Colors.pink]
                  ],
                  onToggle: (index) {
                    print('switched to: $index');
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter first name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter last name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _classController,
                  decoration: InputDecoration(
                    labelText: 'Class',
                    hintText: 'Enter class',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey),
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   child: TextFormField(
              //     controller: _divisionController,
              //     decoration: InputDecoration(
              //       labelText: 'Division',
              //       hintText: 'Enter division',
              //       border: InputBorder.none,
              //       contentPadding: EdgeInsets.all(16),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _rollNumberController,
                  decoration: InputDecoration(
                    labelText: 'Roll Number',
                    hintText: 'Enter roll number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter email Id',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _contactNumberController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    hintText: 'Enter contact number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on password visibility, toggle icon
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _register();
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
