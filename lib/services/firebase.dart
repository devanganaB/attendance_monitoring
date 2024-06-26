import 'package:attendance_monitoring/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Future<void> updateUserCollection(
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

  Future<void> createOrUpdateMetadataSubcollection(String uid) async {
    final metadataRef =
        _firestore.collection('users').doc(uid).collection('metadata');
    final metadataDocRef = metadataRef.doc('info');

    final existingMetadata = await metadataDocRef.get();
    if (existingMetadata.exists) {
      // Update existing metadata document
      await metadataDocRef.update({
        'attendance': FieldValue.increment(5), // Increase attendance by 5
      });
    } else {
      // Create new metadata document
      await metadataRef.doc('info').set({
        'attendance': 5, // Initial attendance value
        'marksPhysics': 0,
        'marksChem': 0,
        'marksMaths': 0,
        'marksJava': 0,
      });
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
        await updateUserCollection(
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
