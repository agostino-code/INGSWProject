
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ratatouilleadmin/app/data/requests/stats_request.dart';

class StatisticsController{

  StatsRequest request = StatsRequest();
  final _startDate=ValueNotifier<DateTime?>(null);
  final _endDate= ValueNotifier<DateTime?>(null);

  DateTime? get startDate => _startDate.value;
  set startDate(DateTime? value) {
    _startDate.value = value;
  }
  ValueListenable<DateTime?> get startDateNotifier => _startDate;

  DateTime? get endDate => _endDate.value;
  set endDate(DateTime? value) {
    _endDate.value = value;
  }
  ValueListenable<DateTime?> get endDateNotifier => _endDate;

  final _selectedWaiter = ValueNotifier<int?>(null);
  int get selectedWaiter => _selectedWaiter.value!;
  set selectedWaiter(int? value) {
    _selectedWaiter.value = value;
  }
  ValueListenable<int?> get selectedWaiterNotifier => _selectedWaiter;

  dynamic selectedColor;

  List<Color> listColors = [
    Colors.pink[400]!,
    Colors.purple[400]!,
    Colors.blue[400]!,
    Colors.green[400]!,
    Colors.yellow[400]!,
    Colors.orange[400]!,
    Colors.red[400]!,
  ];

  Future<int> getNumberOfOrders() async {
    return await request.getNumberOfOrders();
  }
  var outputFormat = DateFormat('dd-MM-yyyy');

  //return data DD-MM-YYYY
  String formatDateTime(DateTime date){
    return outputFormat.format(date);
  }



  Future<List<OrdersData>> getNumberOfOrdersByWaiter() async {
    return OrdersData.fromJsonList(await request.getNumberOfOrdersByWaiter(formatDateTime(startDate!), formatDateTime(endDate!)));
  }

  Future<List<TimeData>> getTotalforDay(String waiter) async {
    return TimeData.fromJsonList(await request.getTotalForWaiter(waiter,formatDateTime(startDate!), formatDateTime(endDate!)));
  }
}

class OrdersData {
  final String _id;
  final String _fullname;
  final int _orders;

  OrdersData(this._id, this._fullname, this._orders);

  String get id => _id;
  String get fullname => _fullname;
  int get orders => _orders;

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(json['_id'], json['waiter'], json['length']);
  }

  static List<OrdersData> fromJsonList(List<dynamic> jsonList) {
    List<OrdersData> stats = [];
    for (int i = 0; i < jsonList.length; i++) {
      stats.add(OrdersData.fromJson(jsonList[i]));
    }
    return stats;
  }
}

class TimeData {
  final String _date;
  final double _total;

  TimeData(this._date, this._total);

  String get date => _date;
  double get total => _total;

  factory TimeData.fromJson(Map<String, dynamic> json) {
    return TimeData(json['date'], json['total']);
  }

  static List<TimeData> fromJsonList(List<dynamic> jsonList) {
    List<TimeData> stats = [];
    for (int i = 0; i < jsonList.length; i++) {
      stats.add(TimeData.fromJson(jsonList[i]));
    }
    return stats;
  }
}


