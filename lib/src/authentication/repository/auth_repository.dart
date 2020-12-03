import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faena/src/authentication/model/sign-user.dart';
import 'package:faena/src/authentication/repository/firebase_auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final _firebaseAuthAPI = FirebaseAuthAPI();

  Future<void> signOut() => _firebaseAuthAPI.signOut();

  Stream<FirebaseUser> onAuthStateChanged() =>
      _firebaseAuthAPI.onAuthStateChanged();

  Stream<FirebaseUser> getUser() => _firebaseAuthAPI.getUser();

  Future<AuthResult> createUserWithEmailAndPassword(SignInUser signInUser) =>
      _firebaseAuthAPI.createUserWithEmailAndPassword(signInUser);

  Future<void> createUserFirestore(String userId, String displayName,
          String photoURL, String email, int role) =>
      _firebaseAuthAPI.createUserFirestore(
          userId, displayName, photoURL, email, role);

  Future<AuthResult> signInWithEmailAndPassword(
          String email, String password) =>
      _firebaseAuthAPI.signInWithEmailAndPassword(email, password);

  Future<FirebaseUser> currentUser() => _firebaseAuthAPI.currentUser();

  Future<void> saveFCMToken(String userId, String fcmToken) =>
      _firebaseAuthAPI.saveFCMToken(userId, fcmToken);

  Future<DocumentSnapshot> getDataUser() => _firebaseAuthAPI.getDataUser();

  Future<void> sendPasswordResetEmail(String email) =>
      _firebaseAuthAPI.sendPasswordResetEmail(email);
}
