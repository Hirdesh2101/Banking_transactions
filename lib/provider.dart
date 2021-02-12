import 'package:flutter/cupertino.dart';
import 'dart:async';
import './database.dart';
import './modals.dart';

class PeopleProvide with ChangeNotifier{
  List<PeopleModal> _items = [];
  List<PeopleModal> get items {
    return [..._items];
  }
  Future<void> fetchAndSetPlaces() async {
    var dbHelper = DBHelper();
    final dataList = await dbHelper.getPeople();
    _items.clear();
    _items = dataList
        .map(
          (item) => PeopleModal(
               name: item.name,
               balance: item.balance,
              ),
        )
        .toList();
    notifyListeners();
  }
  Future<void> update(String name ,String whom,int amount) async {
    var dbHelper = DBHelper();
    await dbHelper.update(name,whom,amount);
    await fetchAndSetPlaces();
    notifyListeners();
  }
}