import 'package:faena/src/faena.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:faena/src/authentication/bloc/bloc_auth.dart';
import 'package:faena/src/authentication/ui/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SesionHandler(),
    );
  }
}

class SesionHandler extends StatefulWidget {
  @override
  _SesionHandlerState createState() => _SesionHandlerState();
}

class _SesionHandlerState extends State<SesionHandler> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authBloc.getUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            FirebaseUser user = snapshot.data;
            if (user == null) {
              return Login();
            } else {
              return Faena();
            }
          } else {
            return Login();
          }
        });
  }
}
