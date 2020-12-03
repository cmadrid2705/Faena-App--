import 'package:faena/src/authentication/bloc/bloc_auth.dart';
import 'package:faena/src/authentication/ui/screens/password_recovery.dart';
import 'package:faena/src/authentication/ui/screens/register.dart';
import 'package:faena/src/home/ui/screens/home.dart';
import 'package:faena/src/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const route = "login";

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  bool _isPasswordHidden = true;
  final _loginForm = GlobalKey<FormState>();
  String email;
  String password;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    authBloc.setIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildUI(),
        StreamBuilder(
          stream: authBloc.loadingStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            loading = snapshot.data ?? false;
            return loading ? Loading() : Container();
          },
        ),
      ],
    );
  }

  Widget _buildUI() {
    return Scaffold(
        // appBar: _createAppbar(context),
       
        body: SafeArea(
           
            child: SingleChildScrollView(
             
          child: Container(
            
            color: Colors.white,
            padding: EdgeInsets.only(top: 50, left: 15, right: 15),
           
            child: Form(
              key: _loginForm,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                        width: 60,
                        height: 80,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('logo.png')))),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        child: _buildEmailTextFiel()),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      child: _buildTextField('Contraseña'),
                    ),
                    GestureDetector(
                      child: Text('¿Olvidaste la contraseña?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue[800])),
                      onTap: () {
                        //Navigator.pushNamed(context, PasswordRecovery.route);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PasswordRecovery()));
                      },
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 80, bottom: 20),
                        child: _loginButton(context, Home.route)),
                    _registerOption(context),
                  ]),
            ),
          ),
        )));
  }

  // Widget _createAppbar(context) {
  //   return AppBar(
  //     title: Text('Iniciar Sesión', style: TextStyle(color: Colors.blue)),
  //     titleSpacing: 10.0,
  //     backgroundColor: Colors.white,
  //   );
  // }

  Widget _buildEmailTextFiel() {
    return TextFormField(
      validator: validateEmail,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => email = value,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
        labelStyle: TextStyle(color: Colors.grey[700]),
        labelText: "* Correo",
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
    );
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

  Widget _buildTextField(String hintText) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Debe introducir una contraseña';
        } else if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        } else {
          return null;
        }
      },
      onChanged: (value) => password = value,
      obscureText: hintText == 'Contraseña' ? _isPasswordHidden : false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        labelStyle: TextStyle(color: Colors.grey[700]),
        labelText: '* $hintText',
        suffixIcon: hintText == 'Contraseña'
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
                icon: _isPasswordHidden == true
                    ? Icon(Icons.visibility_off, color: Colors.grey)
                    : Icon(Icons.visibility, color: Colors.grey),
              )
            : null,
      ),
    );
  }

  Widget _registerOption(context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, Register.route);
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Register()));
      },
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text('¿No tienes cuenta?'),
        Text(
          ' Crear Cuenta',
          style: TextStyle(color: Color(0xff0435d1), fontWeight: FontWeight.w700),
        )
      ]),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.grey[300],
        width: 1.0,
      ),
    );
  }

  Widget _loginButton(context, route) {
    return RaisedButton(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Text('Iniciar Sesión',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w900)),
      colorBrightness: Brightness.dark,
      onPressed: () async {
        final form = _loginForm.currentState;
        form.save();
        if (form.validate()) {
          authBloc.setIsLoading(true);
          try {
            AuthResult result =
                await authBloc.signInWithEmailAndPassword(email, password);
            if (result.user.uid != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false);
              authBloc.setIsLoading(false);
            }
          } on AuthException catch (error) {
            authBloc.setIsLoading(false);
            return _buildErrorDialog(context, error.message);
          } on Exception catch (error) {
            authBloc.setIsLoading(false);
            return _buildErrorDialog(context, error.toString());
          }
        }
      },
      color: Color(0xff0435d1),
    );
  }

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(''),
          content: Text('¡El correo o la contraseña son incorrectas!'),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }

  // Future _buildErrorDialogFB(BuildContext context) {
  //   return showDialog(
  //     builder: (context) {
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         title: Text(''),
  //         content: Text('¡Error al iniciar sesión!'),
  //         actions: <Widget>[
  //           FlatButton(
  //               child: Text('Cancelar'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               })
  //         ],
  //       );
  //     },
  //     context: context,
  //   );
  // }
}
