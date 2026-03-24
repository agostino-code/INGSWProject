import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ratatouilleadmin/app/globals.dart';

import '../models/admin_model.dart';
import '../models/user_model.dart';
import '../provider/api.dart';

class AuthRequest extends MyApiClient {
  dynamic result;

  Future<bool> signIn(String email, String password) async {
    try {
      var response;
      response =
          await post('user/signin', {'email': email, 'password': password});
      //bad request
      if (response.statusCode != 200) {
        response =
            await post('admin/signin', {'email': email, 'password': password});
      }
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await saveToken(jsonData['token']);
        var jsonUser = jsonData['user'] ?? jsonData['admin'];
        if (jsonUser['role'] == 'admin') {
          result = Admin.fromJson(jsonData['admin']);
        } else {
          result = User.fromJson(jsonData['user']);
        }
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return false;
  }

  Future<bool> changePassword(String? oldPassword, String? newPassword,bool firstlogin) async {
    try {
      var response;
      response = await post('user/changepassword',
          {'oldPassword': oldPassword, 'newPassword': newPassword,'firstlogin': firstlogin});
      if (response.statusCode != 200) {
        response = await post('admin/changepassword',
            {'oldPassword': oldPassword, 'newPassword': newPassword,'firstlogin': firstlogin});
      }
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return false;
  }
}
