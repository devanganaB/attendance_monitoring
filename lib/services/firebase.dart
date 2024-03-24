import 'package:attendance_monitoring/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  //Get any Data from Users Collection
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        return null;
      }

      final userDoc =
          FirebaseFirestore.instance.collection("users").doc(currentUser.uid);
      print(userDoc);

      final userData = await userDoc.get();
      print(userData);

      if (userData.exists) {
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
