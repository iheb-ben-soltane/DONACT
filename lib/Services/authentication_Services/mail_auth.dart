import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donact/models/association.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences prefs;

  Future<Association?> signUpWithEmailAndPassword(
      Association association) async {
    try {
      // Perform the user registration with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: association.email,
        password: association.password,
      );

      if (userCredential.user != null) {
        // Registration successful, store additional information in Firestore
        association.Id = userCredential.user!.uid;
        await _firestore.collection('associations').doc(association.Id).set(
              association.userToMap(
                  association), // Assume toMap() converts the Association to a Map
            );

        return association;
      } else {
        // Handle registration failure
        print('Failed to register user');
        return null;
      }
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  Future<Association?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      // Perform user login with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Retrieve additional information from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('associations')
            .doc(userCredential.user!.uid)
            .get();

        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          Association? association = Association.fromMap(userData);
          prefs = await SharedPreferences.getInstance();
          prefs.setString('Id', userCredential.user!.uid);
          prefs.setString('email', email);
          return association;
        } else {
          // Handle missing user data
          print('User data not found');
          return null;
        }
      } else {
        // Handle login failure
        print('Failed to login');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future resetPassword(String mail) async {
    await _auth.sendPasswordResetEmail(email: mail);
  }

  Future<bool> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
