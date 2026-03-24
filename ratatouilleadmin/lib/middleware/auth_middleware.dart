import 'dart:convert';

import '../app/data/models/admin_model.dart';
import '../app/data/models/user_model.dart';
import '../app/data/provider/api.dart';
import '../app/globals.dart';

class AuthMiddleware extends MyApiClient {
  Future<bool> isAlreadyLogIn() async {
    analytics.logEvent(name: 'is_already_login');
    if (await checkToken() && await checkUser() || await checkAdmin()) {
      if (await isValidToken()) {
        return true;
      } else {
        if (await checkAdmin()) {
          deleteAdmin();
        } else {
          deleteUser();
        }
        deleteToken();
        return false;
      }
    } else {
      deleteToken();
      deleteUser();
      deleteAdmin();
      return false;
    }
  }

  Future<bool> isValidToken() async {
    try {
      analytics.logEvent(name: 'is_valid_token');
      isDataLoading = true;
      var response = await get('middleware/check');
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonData['success'];
      } else {
        return jsonData['success'];
      }
    } catch (e) {
      return false;
    } finally {
      isDataLoading = false;
    }
  }

  Future<dynamic> checkFirstLogin() async {
    try {
      analytics.logEvent(name: 'check_first_login');
      isDataLoading = true;
      if (await checkUser()) {
        User result = User.deserialize((await readUser())!);
        return result;
      } else {
        if (await checkAdmin()) {
          Admin result = Admin.deserialize((await readAdmin())!);
          return result;
        } else {
          return null;
        }
      }
    } catch (e) {
      return null;
    } finally {
      isDataLoading = false;
    }
  }
}
