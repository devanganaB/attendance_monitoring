import 'package:attendance_monitoring/screen/home.dart';
import 'package:attendance_monitoring/screen/loginscreen.dart';
import 'package:attendance_monitoring/screen/register.dart';
import 'package:attendance_monitoring/screen/studentscreen.dart';
import 'package:attendance_monitoring/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/login.jpg',
                fit: BoxFit.contain,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixText: "+91 ",
                      hintText: "Enter your Phone number...",
                      suffix: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    validator: (value) {
                      if (value!.length != 10) return "Invalid Phone Number";
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) ;
                  AuthService.sentOtp(
                      phone: _phoneController.text,
                      errorStep: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Error sendign the OTP",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          ),
                      nextStep: () {
                        // Store phone number in Firestore with '+91' prefix
                        AuthService()
                            .addUserToFirestore(_phoneController.text, '', '');
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("OTP Verification"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Enter the OTP"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Form(
                                        key: _formKey1,
                                        child: TextFormField(
                                          controller: _otpController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: "Enter OTP...",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.length != 6)
                                              return "Incorrect OTP";
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                          onPressed: () {
                                            if (_formKey1.currentState!
                                                .validate()) {
                                              AuthService.loginWithOTP(
                                                otp: _otpController.text,
                                              ).then((value) {
                                                if (value == "Success") {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Home(
                                                                  title:
                                                                      'Attendity')));
                                                } else {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              });
                                            }
                                          },
                                          child: Text("Verify OTP")),
                                    )
                                  ],
                                ));
                      });
                },
                child: Text("Send OTP"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()
                                  .animate()
                                  .slideX(delay: Duration(milliseconds: 8))));
                    },
                    child: const Text("Login with Email")),
              ),
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
