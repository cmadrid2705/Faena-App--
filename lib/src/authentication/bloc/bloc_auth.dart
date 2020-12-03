import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faena/src/authentication/model/sign-user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'dart:async';
import 'package:faena/src/authentication/repository/auth_repository.dart';

import 'package:rxdart/rxdart.dart';

class AuthBloc implements Bloc {
  final _authRepository = AuthRepository();
  final userUpdateInfo = UserUpdateInfo();
  //Stream<FirebaseUser> onAuthStateChangedStream = FirebaseAuth.instance.onAuthStateChanged;
  final indexTabSubject = BehaviorSubject<int>();
  Stream<int> get getIndexTabSubject => indexTabSubject.stream;
  void setTabSubject(int index) {
    indexTabSubject.add(index);
  }

  int get indexTabCurrent => indexTabSubject.value;
  final _loadingSubject = BehaviorSubject<bool>();

  Stream<bool> get loadingStream => _loadingSubject.stream;
  void setIsLoading(bool loading) => _loadingSubject.add(loading);

  Stream<FirebaseUser> get getUser => _authRepository.getUser();

  //Future<FirebaseUser> currentUser = FirebaseAuth.instance.currentUser();
  Stream<FirebaseUser> get authStatus => _authRepository.onAuthStateChanged();
  final _cityId = BehaviorSubject<String>();

  setCityId(String cityId) {
    _cityId.add(cityId);
  }

  Stream get getCityId => _cityId.stream;
  String get currentCity => _cityId.value;

  Future<FirebaseUser> currentUser() {
    return _authRepository.currentUser();
  }

  Future<bool> isLoggedin() async {
    bool isLoggedin;
    FirebaseUser user;
    try {
      user = await currentUser();
      if (user != null) {
        isLoggedin = true;
      } else {
        isLoggedin = false;
      }
    } catch (e) {
      isLoggedin = false;
    }
    return isLoggedin;
  }

  Future<void> signOut() {
    return _authRepository.signOut();
  }

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<AuthResult> createUserWithEmailAndPassword(SignInUser signInUser) {
    return _authRepository.createUserWithEmailAndPassword(signInUser);
  }

  Future<void> createUserFirestore(
      userId, displayName, String photoURL, String email, int role) {
    return _authRepository.createUserFirestore(
        userId, displayName, photoURL, email, role);
  }

  Future<void> saveFCMToken(String userId, String fcmToken) {
    return _authRepository.saveFCMToken(userId, fcmToken);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _authRepository.sendPasswordResetEmail(email);
  }

  Future<DocumentSnapshot> getDataUser() {
    return _authRepository.getDataUser();
  }

  @override
  void dispose() {
    _cityId.close();
  }
}

final authBloc = AuthBloc();
