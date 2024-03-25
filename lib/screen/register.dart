import 'package:attendance_monitoring/colors/pallete.dart';
import 'package:attendance_monitoring/screen/home.dart';
import 'package:attendance_monitoring/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

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

  List<String> classOptions = [
    'D12A',
    'D12B',
    'D12C',
    'D15A',
    'D15B',
    'D11AD'
  ]; // Example list of classes

  String? selectedClass = 'D12A';

  // Dummy photo for biometric verification
  String photoUrl = ''; // Provide the URL or path of the photo here
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  bool positive = false;

  String? firstNameError;
  String? lastNameError;
  String? classError;
  String? rollNumberError;
  String? addressError;
  String? emailError;
  String? contactNumberError;
  String? passwordError;

  Future<void> dataindb(String email) async {
    final snapshot =
        await _db.collection("users").where("email", isEqualTo: email).get();
    if (snapshot.size != 0) {
      Fluttertoast.showToast(
          msg: "Email already in use",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Pallete.grey,
          textColor: Pallete.whiteColor,
          fontSize: 16.0);
    } else {
      _register();
    }
  }

  // Function to register the user
  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(userCredential.user?.uid)
      //     .set({
      //   'email': _emailController.text,
      //   'name': '${_firstNameController.text} ${_lastNameController.text}',
      //   'roll': _rollNumberController.text,
      //   'class': selectedClass,
      //   'contact': '+91${_contactNumberController.text}',
      //   'address': _addressController.text,
      //   'role': role,
      //   'isActive': true,
      // });

      final userData = {
        'email': _emailController.text,
        'name': '${_firstNameController.text} ${_lastNameController.text}',
        'roll': _rollNumberController.text,
        'class': selectedClass,
        'contact': '+91${_contactNumberController.text}',
        'address': _addressController.text,
        'role': role,
        'isActive': true,
      };

      // Register the user and create metadata subcollection for students
      if (role == 0) {
        // Create metadata subcollection
        final metadataRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .collection('metadata');
        await metadataRef.doc('info').set({
          'attendance': 0, // Default attendance value
          'marksPhysics': 0, // Default marks for Physics
          'marksChem': 0, // Default marks for Chemistry
          'marksMaths': 0, // Default marks for Mathematics
          'marksJava': 0,
        });
      }

      // Set user data in the 'users' collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userData);

      print("User registered: ${userCredential.user!.email}");
      await Fluttertoast.showToast(
          msg: "Successfully Registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Pallete.grey,
          textColor: Pallete.whiteColor,
          fontSize: 16.0);

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Home(title: "Attendity")));
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
            children: <Widget>[
              Center(
                child: AnimatedToggleSwitch<bool>.dual(
                  current: role == 0 ? true : false,
                  first: true,
                  second: false,
                  spacing: 50.0,
                  style: const ToggleStyle(
                    borderColor: Colors.transparent,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                  borderWidth: 5.0,
                  height: 55,
                  onChanged: (b) => setState(() {
                    role = b ? 0 : 1;
                    print('role is switched to $role');
                  }),
                  styleBuilder: (b) => ToggleStyle(
                    indicatorColor: b ? Colors.orange : Colors.green,
                  ),
                  iconBuilder: (value) =>
                      value ? Icon(Icons.book) : Icon(Icons.circle),
                  textBuilder: (value) => value
                      ? Center(child: Text('Faculty'))
                      : Center(child: Text('Student')),
                ),
              ),
              SizedBox(height: 16),

              buildTextField(
                'First name',
                Icons.person,
                'Enter your first name',
                controller: _firstNameController,
                errorText: firstNameError,
                validator: (value) {
                  setState(() {
                    firstNameError = _validateFirstName(value);
                  });
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildTextField(
                'Last name',
                Icons.person,
                'Enter your last name',
                controller: _lastNameController,
                errorText: lastNameError,
                validator: (value) {
                  setState(() {
                    lastNameError = _validateLastName(value);
                  });
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // buildTextField(
              //   'Class',
              //   Icons.class_,
              //   'Select your class',
              //   controller: _classController,
              //   classOptions: classOptions,
              //   errorText: classError,
              //   validator: (value) {
              //     setState(() {
              //       classError = _validateClass(value);
              //     });
              //     return null;
              //   },
              // ),
              // SizedBox(height: 16),
              // const SizedBox(height: 16),
              buildTextField(
                'Class',
                Icons.class_,
                'Select your class',
                controller: _classController,
                classOptions: classOptions,
                errorText: classError,
                enabled: role == 0,
                validator: (value) {
                  setState(() {
                    classError = _validateClass(value);
                  });
                  return null;
                },
              ),
              SizedBox(height: 16),
              buildTextField(
                'Roll Number',
                Icons.format_list_numbered,
                'Enter roll number',
                controller: _rollNumberController,
                keyboardType: TextInputType.number,
                errorText: rollNumberError,
                enabled: role == 0,
                validator: (value) {
                  setState(() {
                    rollNumberError = _validateRollNumber(value);
                  });
                  return null;
                },
              ),
              SizedBox(height: 16),
              buildTextField(
                'Address',
                Icons.home,
                'Enter your address',
                controller: _addressController,
                errorText: addressError,
                validator: (value) {
                  setState(() {
                    addressError = _validateAddress(value);
                  });
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildTextField(
                'Email',
                Icons.email,
                'Enter your email',
                controller: _emailController,
                errorText: emailError,
                validator: (value) {
                  setState(() {
                    emailError = _validateEmail(value);
                  });
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildTextField(
                'Phone Number',
                Icons.phone,
                'Enter your number',
                controller: _contactNumberController,
                errorText: contactNumberError,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  setState(() {
                    contactNumberError = _validateContactNumber(value);
                  });
                  return null;
                },
              ),
              SizedBox(height: 16),
              PasswordTextField(
                label: 'Password',
                icon: Icons.lock,
                hint: 'Create your password',
                controller: _passwordController,
                validator: (value) {
                  setState(() {
                    passwordError = _validatePassword(value);
                  });
                  return null;
                },
                isPasswordVisible: passwordVisible,
                onVisibilityChanged: (isVisible) {
                  setState(() {
                    passwordVisible = isVisible;
                  });
                  return null;
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    dataindb(_emailController.text.trim());
                  },
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    if (!RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(value)) {
      return 'Name should only contain alphabets and start Capital letters';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    if (!RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(value)) {
      return 'Name should only contain alphabets and start Capital letters';
    }
    return null;
  }

  String? _validateClass(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your class';
    }
    return null;
  }

  String? _validateRollNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your valid roll number';
    }
    if (!RegExp(r'^\d{2}$').hasMatch(value)) {
      return 'Please enter 2 digit  roll number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String regexPattern;
    if (role == 0) {
      regexPattern = r'^20(2[0-9]|3[0-4])\.[a-zA-Z]+\.[a-zA-Z]+@ves\.ac\.in$';
    } else {
      regexPattern = r'.+[a-zA-Z]+\.[a-zA-Z]+@ves\.ac\.in$';
    }
    if (!RegExp(regexPattern).hasMatch(value)) {
      return 'Please enter a valid ves email';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter address';
    }

    return null;
  }

  String? _validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter 10 digits';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
        .hasMatch(value)) {
      return 'Must include letters, numbers and special characters';
    }
    return null;
  }

  bool _validateForm() {
    setState(() {
      firstNameError = _validateFirstName(_firstNameController.text);
      lastNameError = _validateLastName(_lastNameController.text);
      classError = _validateClass(_classController.text);
      rollNumberError = _validateRollNumber(_rollNumberController.text);
      addressError = _validateAddress(_addressController.text);
      emailError = _validateEmail(_emailController.text);
      contactNumberError =
          _validateContactNumber(_contactNumberController.text);
      passwordError = _validatePassword(_passwordController.text);
    });

    return firstNameError == null &&
        lastNameError == null &&
        classError == null &&
        rollNumberError == null &&
        addressError == null &&
        emailError == null &&
        contactNumberError == null &&
        passwordError == null;
  }

  Widget buildTextField(
    String label,
    IconData icon,
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
    List<String>? classOptions,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    String? errorText,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        classOptions != null
            ? DropdownButtonFormField<String>(
                // Dropdown menu for class selection
                value: selectedClass ?? classOptions.first,
                items: classOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: enabled
                    ? (newValue) {
                        setState(() {
                          selectedClass = newValue;
                        });
                        controller!.text = newValue!;
                      }
                    : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(icon,
                      color: enabled ? Pallete.primary : Colors.grey[200]!),
                  hintText: hint,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: enabled ? Pallete.grey : Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Pallete.primary),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorText: errorText,
                ),
              )
            : TextFormField(
                // Regular text field
                controller: controller,
                obscureText: isPassword,
                keyboardType: keyboardType,
                enabled: enabled,
                validator: validator,
                onChanged: (value) {
                  if (validator != null) {
                    String? errorMessage = validator(value);
                    setState(() {
                      print(errorMessage);
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(icon,
                      color: enabled ? Pallete.primary : Colors.grey[200]!),
                  hintText: hint,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: enabled ? Pallete.grey : Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Pallete.primary),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorText: errorText,
                ),
              )
      ],
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool isPasswordVisible;
  final Function(bool) onVisibilityChanged;
  // final String? errorText;

  const PasswordTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.validator,
    required this.isPasswordVisible,
    required this.onVisibilityChanged,
  });
  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: !widget.isPasswordVisible, // Toggle password visibility
          keyboardType: widget.keyboardType,
          validator: widget.validator,

          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: Pallete.primary),
            hintText: widget.hint,
            suffixIcon: IconButton(
              icon: Icon(
                widget.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Pallete.primary,
              ),
              onPressed: () {
                widget.onVisibilityChanged(!widget.isPasswordVisible);
              },
            ),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Pallete.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Pallete.primary),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
