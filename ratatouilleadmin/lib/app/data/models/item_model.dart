import 'package:ratatouilleadmin/app/data/models/category_model.dart';

class Item {
  final String? _id;
  final String _name;
  final String _description;
  final dynamic _price;
  final List<dynamic> _allergens;
  final Categories _category;

  Item(this._id, this._name, this._description, this._price, this._allergens,
      this._category);

  String get id => _id!;
  String get name => _name;
  String get description => _description;
  dynamic get price => _price;
  Categories get category => _category;

  Item.fromJson(Map<String, dynamic> json)
      : _id = json['_id'] as String? ?? '',
        _name = json['name'] as String? ?? '',
        _description = json['description'] as String? ?? '',
        _price = json['price'] as dynamic? ?? '',
        _allergens = List.from(json['allergens']),
        _category = Categories.fromJson(json['category']);

  static List<Item> fromJsonList(List<dynamic> jsonList) {
    List<Item> items = [];
    for (int i = 0; i < jsonList.length; i++) {
      items.add(Item.fromJson(jsonList[i]));
    }
    return items;
  }

  List<String> get allergens {
    List<String> allergens = [];
    for (int i = 0; i < _allergens.length; i++) {
      allergens.add(_allergens[i]);
    }
    return allergens;
  }
}
