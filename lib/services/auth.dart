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

//verify OTP and login
  static Future loginWithOTP({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await FirebaseAuth.instance.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "error in otp login";
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
