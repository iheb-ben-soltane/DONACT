import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Sign in with Google
Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Check if the user canceled the sign-in process
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Await the signInWithCredential call to get the UserCredential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print("User signed successfully");
    // Access the user property from the UserCredential
    final user = userCredential.user;

    // Check if the user already exists in Firestore before adding
    final userExists = await FirebaseFirestore.instance
        .collection("users")
        .where('user mail', isEqualTo: user!.email)
        .get();

    if (userExists.docs.isEmpty) {
      // Add user data to Firestore
      await FirebaseFirestore.instance.collection("users").add({
        'user name': user.displayName,
        'user mail': user.email,
        'user role': '',
      });

      print("User added successfully");
    } else {
      print("User already exists in Firestore");
    }

    return userCredential;
  } catch (e) {
    print('Exception during sign-in: $e');
    return null;
  }
}

// Sign out from Google
Future<bool> signOutFromGoogle() async {
  try {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Sign out from Google
    await GoogleSignIn().signOut();

    return true;
  } catch (e) {
    print('Exception during sign-out: $e');
    return false;
  }
}
