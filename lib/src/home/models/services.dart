import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String uid;
  String name;
  String logo;
  String phone;
  GeoPoint geoPos;
  String schedule;
  String category;

  Service({
    this.uid,
    this.name,
    this.schedule,
    this.logo,
    this.phone,
    this.geoPos,
    this.category,
  });
}
