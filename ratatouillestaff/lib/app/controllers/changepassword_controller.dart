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

  void changePassword() async {
    if (newPassword.value == confirmPassword) {
      User user = User.deserialize((await request.readUser())!);
      if (await request.changePassword(password, newPassword.value)) {
        if (await request.setFirstLogin()) {
          user.firstlogin = false;
          request.saveUser(User.serialize(user));
        }
      }
    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Le password non coincidono!'),
      ));
    }
  }

  void refused() {
    request.deleteToken();
    request.deleteUser();
    myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
  }
}
