import 'package:cloud_firestore/cloud_firestore.dart';

class HomeFirebaseApi {
  Firestore _firestore = Firestore.instance;
  Stream<QuerySnapshot> getCategories() {
    return _firestore.collection('categories').snapshots();
  }

  Stream<QuerySnapshot> getServices(String categoryId) {
    return _firestore
        .collection('services')
        .where('category', isEqualTo: categoryId)
        .snapshots();
  }

  Stream<DocumentSnapshot> getCategoryByID(String uid) {
    return _firestore.collection('categories').document(uid).snapshots();
  }

  Stream<DocumentSnapshot> getServiceById(String uid) {
    return _firestore.collection('services').document(uid).snapshots();
  }
}
