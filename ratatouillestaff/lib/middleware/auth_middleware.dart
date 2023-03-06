import 'dart:convert';

import '../app/data/models/user_model.dart';
import '../app/data/provider/api.dart';

class AuthMiddleware extends MyApiClient {
  Future<bool> isAlreadyLogIn() async {
    if (await checkToken() && await checkUser()) {
      if (await isValidToken()) {
        return true;
      } else {
        deleteToken();
        deleteUser();
        return false;
      }
    } else {
      deleteToken();
      deleteUser();
      return false;
    }
  }

  Future<bool> isValidToken() async {
    try {
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

  Future<User?> checkFirstLogin() async {
    try {
      isDataLoading = true;
      if (await checkUser()) {
        User result = User.deserialize((await readUser())!);
        return result;
      }else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isDataLoading = false;
    }
  }
}
