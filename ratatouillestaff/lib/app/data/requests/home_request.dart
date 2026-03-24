import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ratatouillestaff/app/data/models/order_model.dart';
import 'package:ratatouillestaff/app/data/provider/api.dart';
import 'package:ratatouillestaff/app/globals.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';

class HomeRequest extends MyApiClient {
  Future<List<Categories>> getCategories() async {
    try {
      isDataLoading = true;
      String? userData;
      User? user;
      if (await checkUser()) {
        userData = await readUser();
        user = User.deserialize(userData!);
      } else {
        myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
      }

      String id = user!.restaurant.id;
      var response = await post('category/getall', {'restaurant': id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Categories.fromJsonList(jsonData['categories']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return [];
  }

  Future<List<Item>> getItems(String id) async {
    try {
      isDataLoading = true;
      var response = await post('item/get', {'category': id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Item.fromJsonList(jsonData['items']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return [];
  }

  Future<bool> newOrder(Order order) async {
    try {
      isDataLoading = true;
      var response = await post('order/new', Order.toJson(order));
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        //   content: Text(jsonData['msg']),
        // ));
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return false;
  }

  Future<List<Order>> getOrders() async {
    try {
      isDataLoading = true;
      var response = await get('order/get');
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Order.fromJsonList(jsonData['orders']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return [];
  }

  Future<bool> updateOrder(String id) async {
    try {
      isDataLoading = true;
      var response = await post('order/update', {'id': id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['msg']),
        ));
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return false;
  }

  Future<bool> deleteOrder(String id) async {
    try {
      isDataLoading = true;
      var response = await post('order/delete', {'id': id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['msg']),
        ));
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return false;
  }

  Future<List<Item>> searchItem(String text) async {
    try {
      isDataLoading = true;
      var response = await post('item/search', {'search': text});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Item.fromJsonList(jsonData['items']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error']),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!'),
      ));
    } finally {
      isDataLoading = false;
    }
    return [];
  }
}
