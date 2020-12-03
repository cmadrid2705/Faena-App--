import 'package:faena/src/authentication/ui/screens/password_recovery.dart';
import 'package:faena/src/authentication/ui/screens/login.dart';
import 'package:faena/src/authentication/ui/screens/register.dart';
import 'package:flutter/material.dart';

class AuthRoutes extends StatelessWidget {
  const AuthRoutes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: Login.route,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case Register.route:
            builder = (BuildContext _) => Register();
            break;
          case Login.route:
            builder = (BuildContext _) => Login();
            break;
          case PasswordRecovery.route:
            builder = (BuildContext _) => PasswordRecovery();
            break;
          // case ProfileSettings.route:
          //   builder = (BuildContext _) => ProfileSettings();
          //   break;
          // case Home.route:
          //   builder = (BuildContext _) => Home();
          //   break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
