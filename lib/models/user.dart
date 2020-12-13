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
      this.collaborators}) {
    this.rating ??= 0;
    this.displayName ??= '';
    this.email ??= '';
    this.photoURL ??=
        'https://firebasestorage.googleapis.com/v0/b/faena-543fd.appspot.com/o/placeholder-img.jpg?alt=media&token=a6af15da-5ebd-47b8-a7e8-ce4eeb8c2104';
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
        collaborators = json['collaborators'];

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
        'collaborators': collaborators
      };
}
