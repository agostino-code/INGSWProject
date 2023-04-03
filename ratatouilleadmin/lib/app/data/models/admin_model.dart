import 'dart:convert';

import 'package:ratatouilleadmin/app/data/models/restaurant_model.dart';

class Admin {
  String? _id;
  final String _email;
  final String _name;
  final String _surname;
  final String _role;
  bool _firstlogin;

  Admin(this._email, this._name, this._surname, this._role,
      this._firstlogin);

  String get id => _id!;
  String get email => _email;
  String get name => _name;
  String get surname => _surname;
  String get role => _role;
  bool get firstlogin => _firstlogin;

  set firstlogin(bool value) {
    _firstlogin = value;
  }

  Admin.fromJson(Map<String, dynamic> json)
      : _id = json['_id'] as String? ?? '',
        _email = json['email'] as String? ?? '',
        _name = json['name'] as String? ?? '',
        _surname = json['surname'] as String? ?? '',
        _role = json['role'] as String? ?? '',
        _firstlogin = json['firstlogin'] as bool? ?? false;


  static Map<String, dynamic> toJson(Admin admin) => {
    '_id': admin._id,
    'email': admin._email,
    'name': admin._name,
    'surname': admin._surname,
    'role': admin._role,
    'firstlogin': admin._firstlogin,
  };

  static String serialize(Admin admin) => json.encode(Admin.toJson(admin));

  static Admin deserialize(String json) => Admin.fromJson(jsonDecode(json));
}