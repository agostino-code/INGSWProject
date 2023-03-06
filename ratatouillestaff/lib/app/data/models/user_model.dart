import 'dart:convert';

import 'package:ratatouillestaff/app/data/models/restaurant_model.dart';

class User {
  String? _id;
  final String _email;
  final String _name;
  final String _surname;
  final String _role;
  bool _firstlogin;
  final Restaurant _restaurant;

  User(this._email, this._name, this._surname, this._role, this._restaurant,
      this._firstlogin);

  String get id => _id!;
  String get email => _email;
  String get name => _name;
  String get surname => _surname;
  String get role => _role;
  bool get firstlogin => _firstlogin;
  Restaurant get restaurant => _restaurant;

  set firstlogin(bool value) {
    _firstlogin = value;
  }

  User.fromJson(Map<String, dynamic> json)
      : _id = json['_id'] as String? ?? '',
        _email = json['email'] as String? ?? '',
        _name = json['name'] as String? ?? '',
        _surname = json['surname'] as String? ?? '',
        _role = json['role'] as String? ?? '',
        _firstlogin = json['firstlogin'] as bool? ?? false,
        _restaurant =
            Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>);

  static Map<String, dynamic> toJson(User user) => {
        '_id': user._id,
        'email': user._email,
        'name': user._name,
        'surname': user._surname,
        'role': user._role,
        'firstlogin': user._firstlogin,
        'restaurant': Restaurant.toJson(user._restaurant),
      };

  static String serialize(User user) => json.encode(User.toJson(user));

  static User deserialize(String json) => User.fromJson(jsonDecode(json));
}
