import 'package:flutter/foundation.dart';
import 'package:ratatouilleadmin/app/data/models/item_model.dart';
import 'package:ratatouilleadmin/app/data/models/restaurant_model.dart';
import 'package:ratatouilleadmin/app/data/requests/home_request.dart';

import '../data/models/admin_model.dart';
import '../data/models/category_model.dart';
import '../data/models/user_model.dart';
import '../globals.dart';

class HomeController {
  final HomeRequest request = HomeRequest();

  //final String url = 'http://localhost:5000/';
  final String url = 'https://13.74.188.142:5000/';

  Future<List<Item>> getSelectedItems(String category) async {
    analytics.logEvent(name: 'get_selected_items');
    return await request.getItems(category);
  }

  Future<List<Categories>> getCategories() async {
    analytics.logEvent(name: 'get_categories');
    List<Categories> categories = await request.getCategories();
    _selectedCategory.value ??= categories[0];
    return categories;
  }

  final _selectedCategory = ValueNotifier<Categories?>(null);
  set selectedCategory(Categories? value) {
    _selectedCategory.value = value;
  }
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

  Future<List<String>> getSuggestions(String text) async{
    analytics.logEvent(name: 'get_suggestions');
    return await request.getSuggestions(text);
  }
  Future<List<Item>> searchItems(String text) async{
    analytics.logEvent(name: 'search_items');
    return await request.searchItem(text);
  }

  Future<bool> deleteItem(String id) async{
    analytics.logEvent(name: 'delete_item');
    return await request.deleteItem(id);
  }

  Future<dynamic> getUser() async{
    analytics.logEvent(name: 'get_user');
    if(await request.checkAdmin()) {
      return Admin.deserialize((await request.readAdmin())!);
    } else {
      User user = User.deserialize((await request.readUser())!);
      return user;
    }
  }

  Future<List<Restaurant>> getRestaurants() async{
    analytics.logEvent(name: 'get_restaurants');
    return await request.getRestaurants();
  }

  void setRestaurant(Restaurant restaurant) async{
    analytics.logEvent(name: 'set_restaurant');
    await request.saveRestaurant(Restaurant.serialize(restaurant));
  }

  Future<bool> newCategory(String name) async{
    analytics.logEvent(name: 'new_category');
    return await request.newCategory(name);
  }

  Future<bool> deleteCategory(String id) async{
    analytics.logEvent(name: 'delete_category');
    return await request.deleteCategory(id);
  }

  Future<bool> newItem(Item item) async{
    analytics.logEvent(name: 'new_item');
    return await request.newItem(item);
  }

  Future<bool> categoryChangeIndex(String category, int index) async{
    analytics.logEvent(name: 'category_change_index');
    return await request.categoryChangeIndex(category, index);
  }

  Future<bool> itemChangeIndex(String item, int index) async{
    analytics.logEvent(name: 'item_change_index');
    return await request.itemChangeIndex(item, index);
  }

  Future<List<User>> getUsers() async{
    analytics.logEvent(name: 'get_users');
    return await request.getUsers();
  }

  Future<bool> deleteUser(String id) async{
    analytics.logEvent(name: 'delete_user');
    return await request.removeUser(id);
  }

  Future<bool> changeUserPassword(String id, String password,bool firstlogin) async{
    analytics.logEvent(name: 'change_user_password');
    return await request.userChangePassword(id, password, firstlogin);
  }

  Future<bool> userSignUp(String name, String surname, String email, String password, String role) async{
    analytics.logEvent(name: 'user_sign_up');
    return await request.userSignUp(name, surname, email, password, role);
  }

  Future<bool> generateMenu(String language) async{
    analytics.logEvent(name: 'generate_menu');
    return await request.generateMenu(language);
  }

  Future<Restaurant> getRestaurant() async{
    if(await request.checkAdmin()) {
      Restaurant restaurant = Restaurant.deserialize((await request.readRestaurant())!);
      return restaurant;
    }else{
      User user = User.deserialize((await request.readUser())!);
      return user.restaurant;
    }
  }

  String menuUrl(String language,String restaurant){
    analytics.logEvent(name: 'menu_url');
    return '$url$language/menu/$restaurant';
  }

  Future<void> signOut() async {
    analytics.logEvent(name: 'sign_out');
    request.deleteToken();
    if(await request.checkAdmin()) {
      request.deleteAdmin();
    }else{
      request.deleteUser();
    }
    myAppNavigatorKey.currentState!.pushReplacementNamed('/login');
  }
}
