import 'dart:convert';

class Restaurant {
  final String? _id;
  final String _name;
  final String _owner;

  String get id => _id!;
  String get name => _name;

  Restaurant(this._id, this._name, this._owner);

  Restaurant.fromJson(Map<String, dynamic> json)
      : _id = json['_id'] as String? ?? '',
        _name = json['name'] as String? ?? '',
        _owner = json['owner'] as String? ?? '';

  static Map<String, dynamic> toJson(Restaurant restaurant) => {
        '_id': restaurant._id,
        'name': restaurant._name,
        'owner': restaurant._owner,
      };

  static List<Restaurant> fromJsonList(List<dynamic> jsonList) {
    List<Restaurant> restaurants = [];
    for (int i = 0; i < jsonList.length; i++) {
      restaurants.add(Restaurant.fromJson(jsonList[i]));
    }
    return restaurants;
  }

  static String serialize(Restaurant restaurant) => json.encode(Restaurant.toJson(restaurant));

  static Restaurant deserialize(String json) => Restaurant.fromJson(jsonDecode(json));
}
