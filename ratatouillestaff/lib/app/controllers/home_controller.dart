import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ratatouillestaff/app/data/models/item_model.dart';
import 'package:ratatouillestaff/app/data/requests/home_request.dart';

import '../data/models/category_model.dart';
import '../data/models/order_model.dart';
import '../data/models/user_model.dart';
import '../globals.dart';

class HomeController {
  final HomeRequest request = HomeRequest();

  Future<List<Item>> getSelectedItems(String category) async {
    return await request.getItems(category);
  }

  Future<List<Categories>> getCategories() async {
    List<Categories> categories = await request.getCategories();
    _selectedCategory.value ??= categories[0];
    return categories;
  }

  List<ItemOrder> orderItems = [];
  final lenght = ValueNotifier<int>(0);
  int get orderLenght => lenght.value;
  set orderLenght(int value) {
    lenght.value = value;
  }
  ValueListenable<int> get orderLenghtNotifier => lenght;

  int? table;

  void addItemToOrder(Item item) {
    if (orderItems.any((element) => element.item.id == item.id)) {
      orderItems.firstWhere((element) => element.item.id == item.id).quantity++;
    } else {
      orderItems.add(ItemOrder(item));
    }
  }

  final _selectedCategory = ValueNotifier<Categories?>(null);
  Categories? get selectedCategory => _selectedCategory.value;
  void setSelectedCategory(Categories value) {
    _selectedCategory.value = value;
  }

  ValueListenable<Categories?> get selectedCategoryNotifier =>
      _selectedCategory;

  final _searchText = ValueNotifier<String>('');
  String get searchText => _searchText.value;
  set searchText(String value) {
    _searchText.value = value;
  }
  ValueListenable<String> get searchTextNotifier => _searchText;



  Future<bool> newOrder() async {
    if(orderItems.isEmpty) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Devi prima aggiungere degli elementi all\'ordine!'),
      ));
      return false;
    }
    User user = User.deserialize((await request.readUser())!);
    if(table == null) {
      scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Devi prima fornire il numero del tavolo!'),
      ));
      return false;
    }
    Order order = Order(table!,user.id,orderItems,user.restaurant.id);
    if(await request.newOrder(order)) {
      orderItems = [];
      orderLenght = 0;
      myAppNavigatorKey.currentState!.pushReplacementNamed('/sendendorder',arguments: table);
      table = null;
      return true;
    }
    return false;
  }

  Future<List<Order>> getOrders() async{
    return await request.getOrders();
  }

  Future<bool> updateOrder(String id) async{
    return await request.updateOrder(id);
  }

  Future<bool> deleteOrder(String id) async{
    return await request.deleteOrder(id);
  }

  Future<List<Item>> searchItems(String text) async{
    return await request.searchItem(text);
  }

  Future<User> getUser() async{
    return User.deserialize((await request.readUser())!);
  }

  void signOut() {
    request.deleteToken();
    request.deleteUser();
    myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
  }
}
