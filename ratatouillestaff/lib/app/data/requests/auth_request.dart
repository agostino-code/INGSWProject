import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ratatouillestaff/app/globals.dart';

import '../models/user_model.dart';
import '../provider/api.dart';

class AuthRequest extends MyApiClient {
  User? result;

  Future<bool> signIn(String email, String password) async {
    try {
      isDataLoading = true;
      var response =
          await post('user/signin', {'email': email, 'password': password});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await saveToken(jsonData['token']);
        result = User.fromJson(jsonData['user']);
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return false;
  }

  Future<bool> changePassword(String? oldPassword, String? newPassword,bool firstlogin) async {
    try {
      isDataLoading = true;
      var response = await post('user/changepassword',
          {'oldPassword': oldPassword, 'newPassword': newPassword, 'firstlogin': firstlogin});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return false;
  }

}
