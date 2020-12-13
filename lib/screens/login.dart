import 'package:faena/screens/password_recovery.dart';
import 'package:faena/screens/register.dart';
import 'package:faena/services/firebase_service.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:faena/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import 'home.dart';

class Login extends StatelessWidget  {
  var _isPasswordHidden = RxBool(true);
  final _loginForm = GlobalKey<FormState>();
  String email;
  String password;
  var _loading = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildUI(),
        Obx(() => Visibility(
            visible: _loading.value,
            child: Loading()
        )),
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
                            Get.to(PasswordRecovery());
                          },
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 80, bottom: 20),
                            child: _loginButton()),
                        _registerOption(),
                      ]),
                ),
              ),
            )));
  }

  Widget _buildEmailTextFiel() {
    return TextFormField(
      validator: (val) => !GetUtils.isEmail(val) ? 'Introduce un correo valido' : null,
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

  Widget _buildTextField(String hintText) {
    return Obx(() => TextFormField(
      validator: (value)  => value.isEmpty
          ? 'Debe introducir una contraseña'
          : value.length < 6 ? 'La contraseña debe tener al menos 6 caracteres'
          : null,
      onChanged: (value) => password = value,
      obscureText: hintText == 'Contraseña' ? _isPasswordHidden.value : false,
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
              _isPasswordHidden.value = !_isPasswordHidden.value;
            },
            icon: _isPasswordHidden.value
                ? Icon(Icons.visibility_off, color: Colors.grey)
                : Icon(Icons.visibility, color: Colors.grey)
        )
            : null,
      ),
    ));
  }

  Widget _registerOption() {
    return GestureDetector(
      onTap: () {
        Get.to(Register());
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

  Widget _loginButton() {
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
          _loading.value = true;
          try {
            AuthResult result =
            await firebaseInstance.signInWithEmailAndPassword(email, password);
            if (result.user.uid != null) {
              _loading.value = false;
              firebaseInstance.getUserById(result.user.uid).then((value) {
                stateInstance.signUser = value;
                stateInstance.displayName.value = stateInstance.signUser.displayName;
                Get.offAll(Home());
              });
            }
          } on AuthException catch (error) {
            _loading.value = false;
            return _buildErrorDialog(error.message);
          } on Exception catch (error) {
            _loading.value = false;
            return _buildErrorDialog(error.toString());
          }
        }
      },
      color: Color(0xff0435d1),
    );
  }

  Future _buildErrorDialog(_message) {
    return showDialog(
      context: Get.context,
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
      }
    );
  }
}