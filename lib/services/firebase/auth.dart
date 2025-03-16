import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance; // instance of FirebaseAuth

  User? get currentUser => _firebaseAuth.currentUser; // getter for current user

  Stream<User?> authStateChanges() =>
      _firebaseAuth.authStateChanges(); // stream for auth state changes

  // sign in with email and password
  Future<User?> logInWithEmailAndPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  // sign out
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  // sign up with email and password
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }
}
