import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String photoURL;
  final String pathURL;
  final String uid;
  final int gender;
  final String phoneNumber;
  final displayName;
  final bool visible;
  final String storeUid;

  User({
    Key key,
    this.uid,
    @required this.name,
    @required this.email,
    @required this.photoURL,
    this.pathURL,
    this.gender,
    this.phoneNumber,
    @required this.displayName,
    this.visible,
    this.storeUid
  });
}
