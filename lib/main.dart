import 'package:faena/screens/home.dart';
import 'package:faena/screens/login.dart';
import 'package:faena/services/firebase_service.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SessionHandler(),
    );
  }
}

class SessionHandler extends StatefulWidget {
  @override
  _SessionHandlerState createState() => _SessionHandlerState();
}

class _SessionHandlerState extends State<SessionHandler> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebaseInstance.getUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.data != null) {
            firebaseInstance.getUserById(snapshot.data.uid).then((value) {
              stateInstance.signUser = value;
              stateInstance.displayName.value = stateInstance.signUser.displayName;
            });

              return Home();
          } else {
            return Login();
          }
        },
    );
  }
}
