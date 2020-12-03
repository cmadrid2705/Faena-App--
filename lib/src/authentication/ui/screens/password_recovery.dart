import 'package:faena/src/authentication/bloc/bloc_auth.dart';
import 'package:faena/src/authentication/ui/screens/login.dart';
import 'package:flutter/material.dart';

class PasswordRecovery extends StatefulWidget {
  PasswordRecovery({Key key}) : super(key: key);
  static const route = "password-recovery";

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  TextEditingController controller = new TextEditingController();
  String email;
  bool showAlert = false;
  final _resetPasswordKey = GlobalKey<FormState>();

  @override
  void initState() {
    showAlert = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Form(
            key: _resetPasswordKey,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  (showAlert == true)
                      ? Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 15, bottom: 15),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: <Widget>[
                            Expanded(
                                child: Text(
                                    'Se ha enviado un enlace de restablecimiento de contraseña a $email')),
                            GestureDetector(
                                child: Icon(Icons.close, color: Colors.black),
                                onTap: () {
                                  setState(() {
                                    showAlert = false;
                                    controller =
                                        new TextEditingController(text: '');
                                  });
                                })
                          ]))
                      : Container(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  'Introduce el correo al que le enviaremos una contraseña temporal.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                )))
                      ]),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 30, left: 10, bottom: 10, right: 10),
                      child: TextFormField(
                        controller: controller,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => email = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0)),
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          labelText: "* Correo",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),
                      )),
                  Row(children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: 30, left: 10, bottom: 10, right: 10),
                            child: _buttonResetPassword())),
                  ]),
                  _loginOption(context),
                ]))));
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Introduce un correo valido';
    else
      return null;
  }

  Widget _buttonResetPassword() {
    return RaisedButton(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Text('Enviar',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w900)),
        colorBrightness: Brightness.dark,
        onPressed: () async {
          if (_resetPasswordKey.currentState.validate()) {
            print(email);
            authBloc.sendPasswordResetEmail(email);
            setState(() {
              showAlert = true;
            });
          }
        },
        color: Colors.blue);
  }

  Widget _loginOption(context) {
    return GestureDetector(
        onTap: () {
          //Navigator.pushNamed(context, Login.route);
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Login()));
        },
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            'Iniciar Sesión',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.blue[900], fontWeight: FontWeight.w600),
          ),
        ));
  }
}
