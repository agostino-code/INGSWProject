import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'item_model.dart';

class ItemOrder {
  final Item _item;
  ValueNotifier<int> _quantity = ValueNotifier<int>(1);
  String status = 'pending';


  int get quantity => _quantity.value;
  Item get item => _item;

  set quantity(int value) {
    _quantity.value = value;
  }

  ValueListenable<int> get quantityNotifier => _quantity;

  ItemOrder(this._item);

  ItemOrder.fromJson(Map<String, dynamic> json)
      : _item = Item.fromJson(json['item']),
        _quantity = ValueNotifier<int>(json['quantity'] as int);

  static Map<String, dynamic> toJson(ItemOrder itemOrder) => {
    'item': itemOrder.item.id,
    'quantity': itemOrder._quantity.value,
  };

  static List<Map<String, dynamic>> toJsonList(List<ItemOrder> itemOrders) {
    List<Map<String, dynamic>> items = [];
    for (int i = 0; i < itemOrders.length; i++) {
      items.add(ItemOrder.toJson(itemOrders[i]));
    }
    return items;
  }

  static List<ItemOrder> fromJsonList(List<dynamic> jsonList) {
    List<ItemOrder> items = [];
    for (int i = 0; i < jsonList.length; i++) {
      items.add(ItemOrder.fromJson(jsonList[i]));
    }
    return items;
  }

}

class Order {
  String? _id;
  final int _table;
  final String _waiter;
  final List<ItemOrder> _items;
  String _status = 'pending';
  final String _restaurant;
  DateTime _createdAt = DateTime.now();

  Order(this._table, this._waiter, this._items,this._restaurant);

  String get id => _id!;
  int get table => _table;
  String get waiter => _waiter;
  List<ItemOrder> get items => _items;
  String get status => _status;
  DateTime get createdAt => _createdAt;
  String get restaurant => _restaurant;

  set status(String value) {
    _status = value;
  }

  Order.fromJson(Map<String, dynamic> json)
      : _id = json['_id'] as String,
        _table = json['table'] as int,
        _waiter = json['waiter'] as String,
        _items = ItemOrder.fromJsonList(json['items']),
        _status = json['status'] as String? ?? 'pending',
        _restaurant = json['restaurant'] as String? ?? '',
        _createdAt = DateTime.parse(json['createdAt'] as String);

  static List<Order> fromJsonList(List<dynamic> jsonList) {
    List<Order> orders = [];
    for (int i = 0; i < jsonList.length; i++) {
      orders.add(Order.fromJson(jsonList[i]));
    }
    return orders;
  }

  static Map<String, dynamic> toJson(Order order) => {
      'table': order._table,
      'waiter': order._waiter,
      'items': ItemOrder.toJsonList(order._items),
      'status': order._status,
      'restaurant': order._restaurant,
    };
}

