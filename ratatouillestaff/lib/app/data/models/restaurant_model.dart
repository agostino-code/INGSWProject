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
}
