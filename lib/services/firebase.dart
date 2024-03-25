import 'package:attendance_monitoring/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Future<void> _updateUserCollection(
      String uid, Map<String, dynamic> userData) async {
    try {
      // Get the role of the user
      int role = userData['role'];

      // Prepare data for insertion
      Map<String, dynamic> dataToInsert = {
        'name': userData['name'],
        'address': userData['address'],
        'email': userData['email'],
        'contact': userData['contact'],
      };

      // Update the corresponding collection based on the user's role
      if (role == 0) {
        // Additional fields for students
        dataToInsert.addAll({
          'class': userData['class'],
          'roll': userData['roll'],
        });

        await _firestore.collection("Students").doc(uid).set(dataToInsert);
      } else if (role == 1) {
        await _firestore.collection("Faculty").doc(uid).set(dataToInsert);
      }
    } catch (e, stackTrace) {
      print("Error updating user collection: $e");
      print(stackTrace);
    }
  }

  //Get any Data from Users Collection
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        return null;
      }

      final userDoc = _firestore.collection("users").doc(currentUser.uid);
      print(userDoc);

      final userData = await userDoc.get();
      print(userData);

      if (userData.exists) {
        await _updateUserCollection(
            currentUser.uid, userData.data() as Map<String, dynamic>);

        return userData.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      // Handle the exception
      print("Error getting orders stream: $e");
      print(stackTrace);
      rethrow;
    }
  }
}
