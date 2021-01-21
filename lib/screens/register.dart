import 'package:faena/services/firebase_service.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:faena/utils/constants.dart';
import 'package:faena/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
import 'home.dart';
import 'login.dart';

class Register extends StatelessWidget {
  final _registerForm = GlobalKey<FormState>();
  var _loading = RxBool(false);
  String names;
  String password;
  var _userRole = RxString(Constants.ROLE_CONSUMER);
  final userUpdateInfo = UserUpdateInfo();
  var _isPasswordHidden = RxBool(true);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildUI(),
        Obx(() => Visibility(visible: _loading.value, child: Loading())),
      ],
    );
  }

  _buildUI() {
    return Scaffold(
        appBar: _createAppbar(),
        body: SafeArea(
            left: false,
            right: false,
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
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: _buildeNameTextField(),
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
                        _loginOption(),
                      ]),
                ),
              ),
            )));
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
              _loading.value = true;
              try {
                AuthResult result =
                    await firebaseInstance.createUserWithEmailAndPassword(
                        stateInstance.signUser.email, password);
                final FirebaseUser user = result.user;
                userUpdateInfo.displayName =
                    stateInstance.signUser.displayName = names;
                stateInstance.signUser.uid = user.uid;
                await user.updateProfile(userUpdateInfo);
                await firebaseInstance
                    .createUserFirestore(stateInstance.signUser);
                _loading.value = false;
                firebaseInstance.signInWithEmailAndPassword(
                    stateInstance.signUser.email, password);
                firebaseInstance.getUserById(result.user.uid).then((value) {
                  stateInstance.signUser = value;
                  stateInstance.displayName.value =
                      stateInstance.signUser.displayName;
                });
                Get.offAll(Home());
              } on AuthException catch (error) {
                _loading.value = false;
                return _buildErrorDialog(error.message);
              } on Exception catch (error) {
                _loading.value = false;
                return _buildErrorDialog(error.toString());
              }
            }
          },
          color: Colors.blue,
        ));
  }

  Widget _createAppbar() {
    return AppBar(
      elevation: 0.0,
      titleSpacing: 10.0,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildeNameTextField() {
    return TextFormField(
        validator: (value) =>
            value.isEmpty ? 'El campo no puede ir vacio' : null,
        onChanged: (value) => names = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          labelText: "* Nombres y Apellidos",
          labelStyle: TextStyle(color: Colors.grey[700]),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(7.0),
          ),
        ));
  }

  Widget _buildeEmailTextField() {
    return TextFormField(
        validator: (val) =>
            !GetUtils.isEmail(val) ? 'Introduce un correo valido' : null,
        onChanged: (value) => stateInstance.signUser.email = value,
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
    return Obx(
      () => TextFormField(
          validator: (value) => value.isEmpty
              ? 'Debe introducir una contraseña'
              : value.length < 6
                  ? 'La contraseña debe tener al menos 6 caracteres'
                  : null,
          obscureText:
              'Contraseña' == 'Contraseña' ? _isPasswordHidden.value : false,
          onChanged: (value) => password = value,
          // keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
            labelText: "* Contraseña",
            labelStyle: TextStyle(color: Colors.grey[700]),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(7.0),
            ),
            suffixIcon: 'Contraseña' == 'Contraseña'
                ? IconButton(
                    onPressed: () {
                      _isPasswordHidden.value = !_isPasswordHidden.value;
                    },
                    icon: _isPasswordHidden.value
                        ? Icon(Icons.visibility_off, color: Colors.grey)
                        : Icon(Icons.visibility, color: Colors.grey),
                  )
                : null,
          )),
    );
  }

  Widget _buildeUserRoleTextField() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: DropdownButtonHideUnderline(
            child: Obx(
          () => DropdownButton(
              value: _userRole.value,
              items: [
                DropdownMenuItem(
                    child: Text('Quiero Contratar'),
                    value: Constants.ROLE_CONSUMER),
                DropdownMenuItem(
                    child: Text('Quiero Brindar Servicios (Barbero)'),
                    value: Constants.ROLE_BARBER),
                DropdownMenuItem(
                    child: Text('Quiero Brindar Servicios (Estilista)'),
                    value: Constants.ROLE_STYLIST),
                DropdownMenuItem(
                    child: Text('Quiero Brindar Servicios (Barberia)'),
                    value: Constants.ROLE_BARBERSHOP),
                DropdownMenuItem(
                    child: Text('Quiero Brindar Servicios (Salon)'),
                    value: Constants.ROLE_BEAUTY_SALON)
              ],
              onChanged: (value) {
                stateInstance.signUser.role = value;
                _userRole.value = value;
              }),
        )));
  }

  Widget _loginOption() {
    return GestureDetector(
      onTap: () => Get.to(Login()),
      child: Text(
        'Iniciar Sesión',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.w400),
      ),
    );
  }

  Future _buildErrorDialog(_message) {
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
      context: Get.context,
    );
  }
}
