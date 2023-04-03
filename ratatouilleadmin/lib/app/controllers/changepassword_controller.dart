import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ratatouilleadmin/app/data/requests/auth_request.dart';

import '../data/models/admin_model.dart';
import '../data/models/user_model.dart';
import '../globals.dart';

class ChangePasswordController {
  AuthRequest request = AuthRequest();

  String? password;
  var newPassword = ValueNotifier<String?>('');
  String? confirmPassword;

  ValueListenable<String?> get selectedCategoryNotifier => newPassword;

  changePassword() async {
    if (newPassword.value == confirmPassword) {
      dynamic result;
      if (await request.checkUser()) {
        result = User.deserialize((await request.readUser())!);
      } else {
        result = Admin.deserialize((await request.readAdmin())!);
      }
      if (await request.changePassword(password, newPassword.value,false)) {
          result.firstlogin = false;
          if (await request.checkUser()) {
            request.saveUser(User.serialize(result));
            myAppNavigatorKey.currentState!.pushReplacementNamed('/restaurants');
          } else {
            request.saveAdmin(Admin.serialize(result));
            myAppNavigatorKey.currentState!.pushReplacementNamed('/restaurants');
          }
          scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
            content: Text('Password cambiata con successo!',
                style: TextStyle(color: Colors.white)),
          ));
      }
    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Le password non coincidono!',
            style: TextStyle(color: Colors.white)),
      ));
    }
  }

  refused() async {
    request.deleteToken();
    if (await request.checkUser()) {
      request.deleteUser();
    } else {
      request.deleteAdmin();
    }
    myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
  }
}
