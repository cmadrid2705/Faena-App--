import 'package:flutter/material.dart';

import '../../../authentication/bloc/bloc_auth.dart';
import '../../../authentication/ui/screens/login.dart';

class SettingHome extends StatelessWidget {
  const SettingHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: <Widget>[
        Expanded(child: Text('Ajustes')),
      ])),
      body: Container(
          alignment: Alignment.center,
          child: GestureDetector(
              child: Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Cerrar Sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )),
              onTap: () {
                authBloc.signOut().then((onValue) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false);
                });
              })),
    );
  }
}
