import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyApiClient {
  var isDataLoading = false;

  static String base = "https://13.74.188.142:5000/api/v1/";
  //static String base = "http://localhost:5000/api/v1/";

  //ssl certificate validation
  Future<http.Response> get(String url) async {
    return http.get(Uri.parse(formatUrl(url)), headers: {
      'Accept': 'application/json',
      // "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      // 'Accept': '*/*',
      'Authorization': 'Bearer ${await readToken()}'
    });
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    return http.post(
      Uri.parse(formatUrl(url)),
      headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        // 'Accept': '*/*',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await readToken()}'
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String url,Map<String, dynamic> body) async {
    return http.delete(
      Uri.parse(formatUrl(url)),
      headers: {
        // "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        // 'Accept': '*/*',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await readToken()}'
      },
      body: jsonEncode(body),
    );
  }

  Future<List<String>> getSuggestions(String name) async {
    try{
    var response = await http.get(Uri.parse('https://it.openfoodfacts.org/cgi/search.pl?search_terms=$name&search_simple=true&json=true&fields=product_name'));
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<String> suggestions = [];
      for(var i = 0; i < jsonData['products'].length; i++){
        suggestions.add(jsonData['products'][i]['product_name']);
      }
      return suggestions;
    } else {
      return [];
    }
    }catch(e){
      return [];
    }
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

  saveAdmin(String admin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('admin', admin);
  }

  Future<String?> readAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin');
  }

  deleteAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('admin');
  }

  Future<bool> checkAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('admin');
  }

  saveRestaurant(String restaurant) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('restaurant', restaurant);
  }

  Future<String?> readRestaurant() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('restaurant');
  }

  deleteRestaurant() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('restaurant');
  }

  Future<bool> checkRestaurant() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('restaurant');
  }
}
