class Categories {
  final String? _id;
  final String _name;

  Categories(this._id, this._name);

  String get id => _id!;
  String get name => _name;

  Categories.fromJson(Map<String, dynamic> json)
      : _id = json['_id'] as String? ?? '',
        _name = json['name'] as String? ?? '';

  static List<Categories> fromJsonList(List<dynamic> jsonList) {
    List<Categories> categories = [];
    for (int i = 0; i < jsonList.length; i++) {
      categories.add(Categories.fromJson(jsonList[i]));
    }
    return categories;
  }

  Map<String, dynamic> toJson() => {
        '_id': _id,
        'name': _name,
      };
}
