
//test user sign up home controller

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ratatouilleadmin/app/data/requests/home_request.dart';

HomeRequest request = HomeRequest();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('Test user sign up', () {
    expect(request, isNotNull);
  });
  notValidEmail();
  notValidRole();
  validSignUp1();
  validSignUp2();
  validSignUp3();
}

void validSignUp1() {
  test('Test user sign up with role waiter', () async {
    var result = await request.userSignUp('test', 'test', 'test@test.it', 'test', 'waiter');
    expect(result, true);
  });
}

void validSignUp2(){
  test('Test user sign up with role kitchen', () async {
  var result = await request.userSignUp('test', 'test', 'test@test.it', 'test', 'kitchen');
  expect(result, true);
  });
}

void validSignUp3(){
  test('Test user sign up with role waiter', () async {
    var result = await request.userSignUp('test', 'test', 'test@test.it', 'test', 'supervisor');
    expect(result, true);
  });
}

void notValidEmail() {
  test('Test user sign up', () async {
    var result = await request.userSignUp('test', 'test', 'test', 'test', 'waiter');
    expect(result, false);
  });
}

void notValidRole() {
  test('Test user sign up', () async {
    var result = await request.userSignUp('test', 'test', 'test@test.it', 'test', 'test');
    expect(result, false);
  });
}









