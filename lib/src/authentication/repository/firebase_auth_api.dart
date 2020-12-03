import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faena/src/authentication/model/sign-user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  AuthResult user;

  Stream<FirebaseUser> onAuthStateChanged() {
    return _auth.onAuthStateChanged;
  }

  Future<void> signOut() async {
    final res = await _auth.signOut();
    return res;
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> currentUser() {
    return _auth.currentUser();
  }

  Future<DocumentSnapshot> getDataUser() {
    return currentUser().then((user) {
      return _firestore.collection("users").document(user.uid).get();
    });
  }

  Stream<FirebaseUser> getUser() {
    return _auth.onAuthStateChanged;
  }

  Future<AuthResult> signInWithEmailAndPassword(email, password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<AuthResult> createUserWithEmailAndPassword(SignInUser user) {
    return _auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
  }

  Future<void> createUserFirestore(
    String userId,
    String displayName,
    String photoURL,
    String email,
    int role,
  ) {
    List<dynamic> collaborators = [];
    collaborators.add(userId);
    WriteBatch batch = Firestore.instance.batch();

    DocumentReference userRegistration =
        _firestore.collection('users').document(userId);

    batch.setData(userRegistration, {
      'uid': userId,
      'displayName': displayName,
      'photoURL': photoURL,
      'email': email,
      'role': role,
      'visible': true
    });
    return batch.commit();
  }

  Future<bool> checkUserExist(String userId) async {
    bool exists = false;
    try {
      await _firestore.collection("users").document(userId).get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future addUserFirestore(AuthResult user) async {
    checkUserExist(user.user.uid).then((exists) {
      if (!exists) {
        print("user ${user.user.displayName} ${user.user.email} added");
        _firestore.collection('users').document(user.user.uid).setData({
          'uid': user.user.uid,
          'displayName': user.user.displayName,
          'photoURL': user.user.photoUrl,
          'email': user.user.email,
          'visible': true
        });
      } else {
        return null;
        // print("user ${user.user.displayName} ${user.user.email} exists");
      }
    });
  }

  Future<void> saveFCMToken(String userId, String fcmToken) {
    return _firestore
        .collection("users")
        .document(userId)
        .updateData({"FCMToken": fcmToken});
  }
}

//  getCategoriesRestaurantsAsync() async {
//   QuerySnapshot categories = await  _firestore.collection("categorias").getDocuments();
//   List<String>  listCategories = List<String>();
//   categories.documents.forEach((doc)=>{
//     listCategories.add(doc.documentID)
//   });
//   return listCategories;
// }
