import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ratatouillestaff/app/data/requests/auth_request.dart';

import '../data/models/user_model.dart';
import '../globals.dart';

class ChangePasswordController {
  AuthRequest request = AuthRequest();

  String? password;
  var newPassword = ValueNotifier<String?>('');
  String? confirmPassword;

  ValueListenable<String?> get selectedCategoryNotifier => newPassword;

  changePassword() async {
    analytics.logEvent(name: 'change_password');
    if (newPassword.value == confirmPassword) {
      User user = User.deserialize((await request.readUser())!);
      if (await request.changePassword(password, newPassword.value, false)) {
          user.firstlogin = false;
          request.saveUser(User.serialize(user));
          if(user.role == 'kitchen'){
            myAppNavigatorKey.currentState!.pushReplacementNamed('/kitchenhome');
          } else {
            myAppNavigatorKey.currentState!.pushReplacementNamed('/menu');
          }
          scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
            content: Text('Password cambiata con successo!'),
          ));
          return true;
      }
    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Le password non coincidono!'),
      ));
    }
    return false;
  }

  refused() {
    request.deleteToken();
    request.deleteUser();
    myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
  }
}
