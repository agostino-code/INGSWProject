import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/*
Login test

Methods:
- wrongEmail
- wrongPassword
- correctLogin

Testing Black Box - SECT
 */


void wrongEmail() {
  test('test request signin with wrong email', () async {
    final result = await http.post(Uri.parse('https://13.74.188.142:5000/api/v1/admin/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email':'wrongemail',
          'password':'Temporanea123@'
        }));
    expect(result.statusCode, 400);
  });
}

void wrongPassword() {
  test('test request signin with wrong password', () async {
    final result = await http.post(Uri.parse('https://13.74.188.142:5000/api/v1/admin/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email':'carmen.manna@gmail.com',
          'password':'wrongpassword'
    }));
    expect(result.statusCode, 401);
});
}

void correctLogin() {
  test('test request signin with correct credentials', () async {
    final result = await http.post(Uri.parse('https://13.74.188.142:5000/api/v1/admin/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email':'carmen.manna@gmail.com',
          'password':'Temporanea123@'
        }));
    expect(result.statusCode, 200);
  });
}

void nullEmail() {
  test('test request signin with null email', () async {
    final result = await http.post(
        Uri.parse('https://13.74.188.142:5000/api/v1/admin/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': '',
          'password': 'Temporanea123@'
        }));
    expect(result.statusCode, 400);
  });
}

void nullPassword() {
  test('test request signin with null password', () async {
    final result = await http.post(
        Uri.parse('https://13.74.188.142:5000/api/v1/admin/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': 'carmen.manna@gmail.com',
          'password': ''
        }));
    expect(result.statusCode, 400);
  });
}

nullEmailAndPassword() {
  test('test request signin with null email and password', () async {
    final result = await http.post(
        Uri.parse('https://13.74.188.142:5000/api/v1/admin/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': '',
          'password': ''
        }));
    expect(result.statusCode, 400);
  });
}


void main() {
  HttpOverrides.global = MyHttpOverrides();
  wrongEmail();
  wrongPassword();
  correctLogin();
  nullEmail();
  nullPassword();
  nullEmailAndPassword();
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
