import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Realtime Database Reference
  final DatabaseReference _dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://library-97e7a-default-rtdb.firebaseio.com",
  ).ref();

  // Stream of auth changes
  Stream<User?> get user => _auth.authStateChanges();

  // Updated Sign up to return detailed success/error status
  Future<String?> signUp(String email, String password, String fullName) async {
    try {
      // 1. Create account in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // 2. Get UID
      String uid = userCredential.user!.uid;

      // 3. Save to Realtime Database
      await _dbRef.child("users/$uid").set({
        "fullName": fullName.trim(),
        "email": email.trim(),
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "status": "active",
      });

      print("User registered and saved successfully!");
      return "success";

    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      return e.message; 
    } catch (e) {
      print("Error: $e");
      return e.toString();
    }
  }

  // Updated Login to return success/error message
  Future<String?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), 
          password: password.trim()
      );
      
      User? user = result.user;

      if (user != null) {
        await _dbRef.child("users").child(user.uid).update({
          "lastLogin": DateTime.now().millisecondsSinceEpoch,
        });
      }

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print("Login error: $e");
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
