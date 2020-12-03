import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faena/src/home/models/category.dart';
import 'package:faena/src/home/models/services.dart';
import 'package:faena/src/home/repository/home_repository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../models/category.dart';

class HomeBloc implements Bloc {
  final _homeRepository = HomeRepository();

  Stream<QuerySnapshot> getCategories() {
    return _homeRepository.getCategories();
  }

  Stream<QuerySnapshot> getServices(String categoryId) {
    return _homeRepository.getServices(categoryId);
  }

  Stream<DocumentSnapshot> getCategoryByID(String uid) {
    return _homeRepository.getCategoryByID(uid);
  }

  Stream<DocumentSnapshot> getServiceById(String uid) {
    return _homeRepository.getServiceById(uid);
  }

  Category buildCategoryDetail(DocumentSnapshot doc) {
    Category category = Category(
        uid: doc.documentID,
        description: doc.data['description'],
        name: doc.data['name'],
        photoURL: doc.data['photoURL']);
    return category;
  }

  List<Category> buildListCategory(List<DocumentSnapshot> categoryList) {
    List<Category> category = List<Category>();

    categoryList.forEach((c) {
      category.add(Category(
        uid: c.documentID,
        name: c.data['name'],
        description: c.data['description'],
        photoURL: c.data['photoURL'],
      ));
    });
    return category;
  }

  List<Service> buildListServices(List<DocumentSnapshot> serviceList) {
    List<Service> service = List<Service>();
    serviceList.forEach((c) {
      service.add(Service(
          uid: c.documentID,
          name: c.data['name'],
          category: c.data['category'],
          logo: c.data['logo'],
          schedule: c.data['schedule'],
          phone: c.data['phone'],
          geoPos: c.data['geoPos']));
    });
    return service;
  }

  Service buildServiceDetail(DocumentSnapshot doc) {
    Service category = Service(
      uid: doc.documentID,
      name: doc.data['name'],
      category: doc.data['category'],
      logo: doc.data['logo'],
      schedule: doc.data['schedule'],
      phone: doc.data['phone'],
      geoPos: doc.data['geoPos'],
    );
    return category;
  }

  void dispose() {}
}

final homeBloc = HomeBloc();
