import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String verifyId = "";

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // Fetch user data from Firestore based on UID
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      // Query user document from Firestore
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if user data exists
      if (userData.exists) {
        // Extract name and email from user data
        final userName = userData['name'];
        final userEmail = userData['email'];

        // Return user data as a map
        return {'name': userName, 'email': userEmail};
      } else {
        // User document not found
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // register
  Future<void> addUserToFirestore(
      String userId, String username, String email) async {
    try {
      // Check if 'users' collection exists, create it if not
      CollectionReference usersCollection = _firestore.collection('users');

      if (!(await usersCollection.doc(userId).get()).exists) {
        await usersCollection.doc(userId).set({});
      }

      // Add user data to the 'users' collection
      await usersCollection.doc(userId).set({
        'name': username,
        'email': email,
      });
    } catch (e) {
      print('Error adding user to Firestore: $e');
      throw e;
    }
  }

  // send otp
  static Future sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            timeout: Duration(seconds: 30),
            phoneNumber: "+91$phone",
            verificationCompleted: (PhoneAuthCredential) async {
              return;
            },
            verificationFailed: (error) {
              return;
            },
            codeSent: (verificationId, forceResendingToken) async {
              verifyId = verificationId;
              nextStep();
            },
            codeAutoRetrievalTimeout: (verificationId) async {
              return;
            })
        .onError((error, stackTrace) {
      errorStep();
    });
  }

//   // send otp
//   static Future sentOtp({
//     required String phone,
//     required Function errorStep,
//     required Function nextStep,
//   }) async {
//     await FirebaseAuth.instance
//         .verifyPhoneNumber(
//             timeout: Duration(seconds: 30),
//             phoneNumber: "+91$phone",
//             verificationCompleted: (PhoneAuthCredential) async {
//               return;
//             },
//             verificationFailed: (error) {
//               return;
//             },
//             codeSent: (verificationId, forceResendingToken) async {
//               verifyId = verificationId;
//               nextStep();
//             },
//             codeAutoRetrievalTimeout: (verificationId) async {
//               return;
//             })
//         .onError((error, stackTrace) {
//       errorStep();
//     });
//   }

// //verify OTP and login
//   static Future loginWithOTP({required String otp}) async {
//     final cred =
//         PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

//     try {
//       final userCredential =
//           await FirebaseAuth.instance.signInWithCredential(cred);
//       final user = userCredential.user;
//       if (user != null) {
//         // Fetch user data from Firestore based on UID
//         final userData = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid) // Query based on UID instead of phone number
//             .get();

//         if (userData.exists) {
//           // User found, fetch name and email
//           final userName = userData['name'];
//           final userEmail = userData['email'];

//           // Navigate to home screen or do further operations with user data
//           return {'name': userName, 'email': userEmail};
//         } else {
//           // User not found in Firestore
//           return 'User not found';
//         }
//       } else {
//         // User is null
//         return 'Error logging in';
//       }
//     } on FirebaseAuthException catch (e) {
//       return e.message.toString();
//     } catch (e) {
//       return e.toString();
//     }
//   }

  //verify OTP and login
  static Future loginWithOTP({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await FirebaseAuth.instance.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return 'error in otp login';
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  //logout
  static Future<void> logout() async {
    try {
      // Update isActive field to false
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'isActive': false});
      }
      // Sign out
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Check whether user is logged in
  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if isActive field is true
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        return userData['isActive'] ?? false;
      }
    }
    return false;
  }
}
