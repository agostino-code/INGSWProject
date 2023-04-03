import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ratatouilleadmin/app/data/provider/api.dart';

import '../../globals.dart';
import '../models/restaurant_model.dart';

class StatsRequest extends MyApiClient {
  String _id = '';
  String get id => _id;

  StatsRequest() {
    setid();
  }

  setid() async {
    _id = Restaurant.deserialize((await readRestaurant())!).id;
  }

  Future<int> getNumberOfOrders() async {
    try {
      var response = await post('stats/numberoforders', {'restaurant': id});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonData['length'];
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
    return 0;
  }

  Future<dynamic> getNumberOfOrdersByWaiter(String start,String end) async {
    try {
      var response = await post('stats/numberofordersbywaiter', {'restaurant': id,'start':start,'end':end});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonData['result'];
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
  }

  Future<dynamic> getTotalForWaiter(String waiter,String start,String end) async {
    try {
      var response = await post('stats/totalforwaiter', {'restaurant': id,'waiter': waiter,'start':start,'end':end});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonData['result'];
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
  }
}
