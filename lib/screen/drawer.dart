import 'package:attendance_monitoring/colors/pallete.dart';
import 'package:attendance_monitoring/screen/loginscreen.dart';
import 'package:attendance_monitoring/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user name when the widget initializes
  }

  Future<void> _fetchUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        setState(() {
          _userName = userSnapshot['name'];
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final email = user!.email;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child:
                ListView(padding: EdgeInsets.zero, shrinkWrap: true, children: [
              Stack(children: [
                UserAccountsDrawerHeader(
                  accountName: Text(_userName), // Display user name
                  accountEmail: Text(email!), // Display user email
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  decoration: BoxDecoration(
                    color: Pallete
                        .bgprimary, // Change this color to the desired blue shade
                  ),
                ),
              ]),
            ]),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Logout",
                    ),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          AuthService.logout();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                          // SystemNavigator.pop();
                          // SystemNavigator.pop();
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}


// await FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(userCredential.user?.uid)
//                               .set({});