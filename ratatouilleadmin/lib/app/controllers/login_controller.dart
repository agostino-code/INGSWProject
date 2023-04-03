import 'package:flutter/material.dart';
import 'package:ratatouilleadmin/app/globals.dart';

import '../data/models/admin_model.dart';
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

  dynamic get user => request.result!;

  login() async {
    analytics.logEvent(name: 'login');
    if (await request.signIn(email, password)) {
        if (request.result!.role == 'admin') {
          request.saveAdmin(Admin.serialize(request.result!));
          if (request.result!.firstlogin == true) {
            myAppNavigatorKey.currentState!.pushReplacementNamed('/changepassword',arguments: true);
            return;
          }
          myAppNavigatorKey.currentState!.pushReplacementNamed('/restaurants');
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text('Benvenuto ${request.result.name}!',
                style: const TextStyle(color: Colors.white)),
          ));
        } else {
          if (request.result!.role == 'supervisor') {
            request.saveUser(User.serialize(request.result!));
            if (request.result!.firstlogin == true) {
              myAppNavigatorKey.currentState!.pushReplacementNamed('/changepassword',arguments: true);
              return;
            }
            myAppNavigatorKey.currentState!.pushReplacementNamed('/menu',arguments: true);
            scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
              content: Text('Benvenuto ${user.name}!',style: const TextStyle(color: Colors.white)),
            ));
          } else {
            request.deleteToken();
            request.deleteUser();
            scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text('Hai bisogno di Ratatouille Staff!',
                  style: TextStyle(color: Colors.white)),
            ));
          }
        }
    }
  }
}
