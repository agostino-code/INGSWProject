import 'package:flutter/material.dart';
import 'package:ratatouillestaff/app/globals.dart';

import '../data/models/user_model.dart';
import '../data/requests/auth_request.dart';

class LoginController {
  final AuthRequest request = AuthRequest();

  String _email = '';
  String _password = '';

  String get email => _email;
  String get password => _password;

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  User get user => request.result!;

  login() async {
    analytics.logEvent(name: 'login');
    if (await request.signIn(email, password)) {
      request.saveUser(User.serialize(request.result!));
        if (request.result!.role == 'kitchen') {
          if (request.result!.firstlogin == true) {
            myAppNavigatorKey.currentState!.pushReplacementNamed('/changepassword',arguments: true);
            return;
          }
          myAppNavigatorKey.currentState!.pushReplacementNamed('/kitchenhome');
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text('Benvenuto ${user.name}!'),
          ));
        } else {
          if (request.result!.firstlogin == true) {
            myAppNavigatorKey.currentState!.pushReplacementNamed('/changepassword',arguments: true);
            return;
          }
          if (request.result!.role == 'waiter') {
            myAppNavigatorKey.currentState!.pushReplacementNamed('/menu');
            scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
              content: Text('Benvenuto ${user.name}!'),
            ));
          } else {
            request.deleteToken();
            request.deleteUser();
            scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text('Hai bisogno di Ratatouille Admin!'),
            ));
          }
        }
    }
  }
}
