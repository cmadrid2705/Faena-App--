import 'package:faena/utils/constants.dart';

class User {
  String displayName;
  String email;
  String photoURL;
  String role;
  String uid;
  int rating;
  String phone;
  String schedule;
  String description;
  String collaborators;
  String images;
  double earnings;

  User(
      {this.displayName,
      this.email,
      this.photoURL,
      this.role,
      this.uid,
      this.rating,
      this.phone,
      this.schedule,
      this.description,
      this.collaborators,
      this.images = '',
        this.earnings = 0.0}) {
    this.rating ??= 0;
    this.displayName ??= '';
    this.email ??= '';
    this.photoURL ??=
        Constants.PLACEHOLDER_IMAGE_URL;
    this.role ??= Constants.ROLE_CONSUMER;
    this.uid ??= '';
    this.phone ??= 'sin numero';
    this.schedule = 'sin horario';
    this.description ??= 'sin descripcion';
    this.collaborators ??= '';
  }

  User.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        email = json['email'],
        photoURL = json['photoURL'],
        role = json['role'],
        uid = json['uid'],
        rating = json['rating'],
        phone = json['phone'],
        schedule = json['schedule'],
        description = json['description'],
        collaborators = json['collaborators'],
        images = json['images'] ?? '',
        earnings = json['earnings'] == null ? 0.0 : json['earnings'] is int ? (json['earnings'] as int).toDouble() : json['earnings'];

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'email': email,
        'photoURL': photoURL,
        'role': role,
        'uid': uid,
        'rating': rating,
        'phone': phone,
        'schedule': schedule,
        'description': description,
        'collaborators': collaborators,
        'images': images,
        'earnings': earnings,
      };
}
