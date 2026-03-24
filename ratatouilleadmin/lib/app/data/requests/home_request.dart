import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ratatouilleadmin/app/data/models/restaurant_model.dart';
import 'package:ratatouilleadmin/app/data/provider/api.dart';
import 'package:ratatouilleadmin/app/globals.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';

class HomeRequest extends MyApiClient {
  Future<List<Categories>> getCategories() async {
    try {
      String? id;
      if (await checkUser()) {
        id = User.deserialize((await readUser())!).restaurant.id;
      } else {
        if (await checkAdmin()) {
          id = Restaurant.deserialize((await readRestaurant())!).id;
        } else {
          myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
        }
      }
      var response = await post('category/getall', {'restaurant': id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Categories.fromJsonList(jsonData['categories']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return [];
  }

  Future<bool> deleteCategory(String id) {
    try {
      return delete('category/delete', {'category': id}).then((value) {
        var jsonData = jsonDecode(value.body);
        if (value.statusCode == 200) {
          return true;
        } else {
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text(jsonData['error'],
                style: const TextStyle(color: Colors.white)),
          ));
        }
        return false;
      });
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
      return Future.value(false);
    }
  }

  Future<bool> newCategory(String name) async {
    try {
      String? restaurant;
      if (await checkUser()) {
        restaurant = User.deserialize((await readUser())!).restaurant.id;
      } else {
        if (await checkAdmin()) {
          restaurant = Restaurant.deserialize((await readRestaurant())!).id;
        } else {
          myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
        }
      }
      return post('category/new', {'name': name, 'restaurant': restaurant})
          .then((value) {
        var jsonData = jsonDecode(value.body);
        if (value.statusCode == 201) {
          return true;
        } else {
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text(jsonData['error'],
                style: const TextStyle(color: Colors.white)),
          ));
        }
        return false;
      });
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
      return Future.value(false);
    }
  }

  Future<List<Item>> getItems(String id) async {
    try {
      var response = await post('item/get', {'category': id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Item.fromJsonList(jsonData['items']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return [];
  }

  Future<List<Item>> searchItem(String text) async {
    try {
      var response = await post('item/search', {'search': text});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Item.fromJsonList(jsonData['items']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return [];
  }

  Future<bool> deleteItem(String id) {
    try {
      return delete('item/delete', {'item': id}).then((value) {
        var jsonData = jsonDecode(value.body);
        if (value.statusCode == 200) {
          return true;
        } else {
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text(jsonData['error'],
                style: const TextStyle(color: Colors.white)),
          ));
        }
        return false;
      });
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
      return Future.value(false);
    }
  }

  Future<bool> newItem(Item item) async {
    try {
      String? restaurant;
      if (await checkUser()) {
        restaurant = User.deserialize((await readUser())!).restaurant.id;
      } else {
        if (await checkAdmin()) {
          restaurant = Restaurant.deserialize((await readRestaurant())!).id;
        } else {
          myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
        }
      }
      return post('item/new', {
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'category': item.category.id,
        'allergens': item.allergens,
        'restaurant': restaurant
      }).then((value) {
        var jsonData = jsonDecode(value.body);
        if (value.statusCode == 201) {
          return true;
        } else {
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text(jsonData['error'],
                style: const TextStyle(color: Colors.white)),
          ));
        }
        return false;
      });
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
      return Future.value(false);
    }
  }

  Future<bool> categoryChangeIndex(category, index){
    try{
      return post('category/changeindex', {'category': category, 'index': index}).then((value){
        var jsonData = jsonDecode(value.body);
        if(value.statusCode == 200){
          return true;
        }else{
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text(jsonData['error'],
                style: const TextStyle(color: Colors.white)),
          ));
        }
        return false;
      });
    }catch(e){
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
      return Future.value(false);
    }
  }

  Future<bool> itemChangeIndex(item, index){
    try{
      return post('item/changeindex', {'item': item, 'index': index}).then((value){
        var jsonData = jsonDecode(value.body);
        if(value.statusCode == 200){
          return true;
        }else{
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text(jsonData['error'],
                style: const TextStyle(color: Colors.white)),
          ));
        }
        return false;
      });
    }catch(e){
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
      return Future.value(false);
    }
  }

  Future<List<Restaurant>> getRestaurants() async {
    try {
      var response = await get('admin/restaurants');
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Restaurant.fromJsonList(jsonData['restaurants']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return [];
  }

  Future<List<User>> getUsers() async {
    try {
      var restaurant = Restaurant.deserialize((await readRestaurant())!);
      var response = await post('restaurant/getusers', {'restaurant': restaurant.id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return User.fromJsonList(jsonData['users']);
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return [];
  }

  Future<bool> removeUser(String id) async {
    try{
      var response = await post('user/delete', {'user': id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    }catch(e){
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return false;
  }

  Future<bool> userChangePassword(String user,String password,bool firstlogin) async {
    try{
      var response = await post('user/forcechangepassword', {'newPassword': password, 'firstlogin': firstlogin, 'user': user});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    }catch(e){
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return false;
  }

  Future<bool> userSignUp(String name, String surname, String email, String password , String role) async {
    try{
      Restaurant restaurant = Restaurant.deserialize((await readRestaurant())!);
      var response = await post('user/signup', {'name': name,'surname':surname,'email': email,'role': role,'password':password,'restaurant': restaurant.id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return true;
      } else {
        if(scaffoldMessengerKey.currentState != null) {
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
        }
      }
    }catch(e){
      if(scaffoldMessengerKey.currentState != null) {
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
          content: Text('Errore di connessione!',
              style: TextStyle(color: Colors.white)),
        ));
      }
    }
    return false;
  }

  Future<bool> generateMenu(String language) async {
    try{
      Restaurant restaurant = Restaurant.deserialize((await readRestaurant())!);
      var response = await post('restaurant/translate/category', {'language': language,'restaurant': restaurant.id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        await Future.delayed(const Duration(seconds: 30));
        var response = await post('restaurant/translate/item', {'language': language,'restaurant': restaurant.id});
        jsonData = jsonDecode(response.body);
        if (response.statusCode == 201) {
          await Future.delayed(const Duration(seconds: 30));
          return true;
        } else {
          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text(jsonData['error'],
                style: const TextStyle(color: Colors.white)),
          ));
        }
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(jsonData['error'],
              style: const TextStyle(color: Colors.white)),
        ));
      }
    }catch(e){
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Errore di connessione!',
            style: TextStyle(color: Colors.white)),
      ));
    }
    return false;
  }

}
