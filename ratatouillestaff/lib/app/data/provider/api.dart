import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyApiClient {
  var isDataLoading = false;

  static String base = "http://13.74.188.142:5000/api/v1/";
  // static String base = "http://localhost:5000/api/v1/";

  Future<http.Response> get(String url) async {
    return http.get(Uri.parse(formatUrl(url)), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await readToken()}'
    });
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    return http.post(
      Uri.parse(formatUrl(url)),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await readToken()}'
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    return http.put(
      Uri.parse(formatUrl(url)),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await readToken()}'
      },
      body: jsonEncode(body),
    );
  }


  String formatUrl(String url) {
    return base + url;
  }

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  saveUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user);
  }

  Future<String?> readUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  Future<bool> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user');
  }
}
