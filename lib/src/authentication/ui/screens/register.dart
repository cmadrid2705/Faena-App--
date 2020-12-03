import 'package:faena/src/authentication/bloc/bloc_auth.dart';
import 'package:faena/src/authentication/model/sign-user.dart';
import 'package:faena/src/authentication/ui/screens/login.dart';
import 'package:faena/src/home/ui/screens/home.dart';
import 'package:faena/src/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  static const route = "register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _registerForm = GlobalKey<FormState>();
  final userUpdateInfo = UserUpdateInfo();
  bool loading = false;
  bool _isPasswordHidden = true;
  SignInUser signUser = SignInUser();
  int _userRole = 1;
  List<dynamic> collaborators = [];

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

  _buildUI() {
    return Scaffold(
        appBar: _createAppbar(context),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 5, left: 15, right: 15),
            child: Form(
              key: _registerForm,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Crear Cuenta',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: _buildeNameTextField(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: _buildeLastNameTextField(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: _buildeEmailTextField(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: _buildePasswordTextField(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: _buildeUserRoleTextField(),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: _registerButton()),
                    // _facebookButton(context, RegisterOptions.route),
                    _loginOption(context),
                  ]),
            ),
          ),
        )));
  }

  Widget _createAppbar(context) {
    return AppBar(
      elevation: 0.0,
      titleSpacing: 10.0,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildeNameTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'El campo no puede ir vacio';
          } else {
            return null;
          }
        },
        // obscureText: hintText == 'Contraseña' ? _isPasswordHidden : false,
        //obscureText: false,
        onChanged: (value) => signUser.name = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          labelText: "* Nombres",
          labelStyle: TextStyle(color: Colors.grey[700]),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(7.0),
          ),
        ));
  }

  Widget _buildeLastNameTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'El campo no puede ir vacio';
          } else {
            return null;
          }
        },
        // obscureText: hintText == 'Contraseña' ? _isPasswordHidden : false,
        //obscureText: 'Nombre',
        onChanged: (value) => signUser.lastname = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          labelText: "* Apellidos",
          labelStyle: TextStyle(color: Colors.grey[700]),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(7.0),
          ),
        ));
  }

  Widget _buildeEmailTextField() {
    return TextFormField(
        validator: validateEmail,
        // obscureText: hintText == 'Contraseña' ? _isPasswordHidden : false,
        //obscureText: 'Nombre',
        onChanged: (value) => signUser.email = value,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          labelText: "* Correo",
          labelStyle: TextStyle(color: Colors.grey[700]),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(7.0),
          ),
        ));
  }

  Widget _buildePasswordTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Debe introducir una contraseña';
          } else if (value.length < 6) {
            return 'La contraseña tener debe al menos 6 caracteres';
          } else {
            return null;
          }
        },
        obscureText: 'Contraseña' == 'Contraseña' ? _isPasswordHidden : false,
        onChanged: (value) => signUser.password = value,
        // keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          labelText: "* Contraseña",
          labelStyle: TextStyle(color: Colors.grey[700]),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(7.0),
          ),
          suffixIcon: 'Contraseña' == 'Contraseña'
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
        ));
  }

  Widget _buildeUserRoleTextField() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: DropdownButtonHideUnderline(
            child: DropdownButton(
                value: _userRole,
                items: [
                  DropdownMenuItem(child: Text('Quiero Contratar'), value: 1),
                  DropdownMenuItem(
                      child: Text('Quiero Brindar Mis Servicios'), value: 2)
                ],
                onChanged: (value) {
                  setState(() {
                    _userRole = value;
                  });
                })));
  }

  Widget _loginOption(context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Login()));
      },
      child: Text(
        'Iniciar Sesión',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.w400),
      ),
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

  Widget _registerButton() {
    return Container(
        margin: EdgeInsets.only(top: 80),
        child: RaisedButton(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Text('Registrate',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w900)),
          colorBrightness: Brightness.dark,
          onPressed: () async {
            if (_registerForm.currentState.validate()) {
              authBloc.setIsLoading(true);
              try {
                AuthResult result =
                    await authBloc.createUserWithEmailAndPassword(signUser);
                final FirebaseUser user = result.user;
                userUpdateInfo.displayName =
                    signUser.name + " " + signUser.lastname;
                await user.updateProfile(userUpdateInfo);
                await authBloc.createUserFirestore(user.uid,
                    userUpdateInfo.displayName, "", user.email, _userRole);
                authBloc.setIsLoading(false);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false);
              } on AuthException catch (error) {
                authBloc.setIsLoading(false);
                return _buildErrorDialog(context, error.message);
              } on Exception catch (error) {
                authBloc.setIsLoading(false);
                return _buildErrorDialog(context, error.toString());
              }
            }
          },
          color: Colors.blue,
        ));
  }

  // Widget _facebookButton(context, route) {
  //   return Container(
  //       margin: EdgeInsets.only(top: 10, bottom: 30),
  //       child: RaisedButton(
  //         padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Icon(
  //               FindeAppIcons.facebook,
  //               color: Colors.white,
  //               size: 14,
  //             ),
  //             Text('Registrarse con Facebook',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 15.0,
  //                     fontWeight: FontWeight.w900)),
  //           ],
  //         ),
  //         colorBrightness: Brightness.dark,
  //         onPressed: () {
  //           authBloc.setIsLoading(true);
  //           authBloc.singInWithFacebook(context).then((result) {
  //             authBloc.setIsLoading(false);
  //             Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => Finde()),
  //                 (Route<dynamic> route) => false);
  //           }).catchError((error) {
  //             authBloc.setIsLoading(false);
  //             print("Error $error");
  //           });
  //         },
  //         color: Colors.blue[900],
  //       ));
  // }

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Mensaje De Error'),
          content: (_message ==
                  "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)")
              ? Text(
                  '¡La dirección de correo electrónico ya está en uso por otra cuenta!')
              : Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
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
}
