import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faena/src/home/repository/home_firestore_api.dart';

class HomeRepository {
  final _homeFirebaseApi = HomeFirebaseApi();

  Stream<QuerySnapshot> getCategories() => _homeFirebaseApi.getCategories();

  Stream<DocumentSnapshot> getCategoryByID(String uid) =>
      _homeFirebaseApi.getCategoryByID(uid);

  Stream<QuerySnapshot> getServices(String categoryId) =>
      _homeFirebaseApi.getServices(categoryId);

  Stream<DocumentSnapshot> getServiceById(String uid) =>
      _homeFirebaseApi.getServiceById(uid);
}
