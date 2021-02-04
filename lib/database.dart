import 'dart:async';
import 'dart:io' as io;
import 'package:banking_app/modals.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper with ChangeNotifier {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "data.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE People(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,balance REAL)");  
    await insert(db);
    notifyListeners();
  }
  Future insert(Database db)async{
    var dbClient = db;
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Hirdesh',3.1416]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Yogesh',10.1416]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Atul',1.1416]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Chirag',3000.1416]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Dev',8.1416]);  
  }
  Future<List<PeopleModal>> getPeople() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM People');
    List<PeopleModal> people = [];
    for (int i = 0; i < list.length; i++) {
      people.add(new PeopleModal(list[i]["name"],list[i]["balance"]));
    }
    return people;
  }
  Future<List<PeopleModal>> getTransPeople(String name) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM People WHERE name!=?',['$name']);
    List<PeopleModal> people = [];
    for (int i = 0; i < list.length; i++) {
      people.add(new PeopleModal(list[i]["name"],list[i]["balance"]));
    }
    return people;
  }
  update(String name ,String whom , double amount) async {
    var dbClient = await db;
    List<Map> temp1 = await dbClient.rawQuery('SELECT * FROM People WHERE name=?',['$name']);
    List<Map> temp2 = await dbClient.rawQuery('SELECT * FROM People WHERE name=?',['$whom']);

    await dbClient.rawUpdate(
       '''
       UPDATE People
       SET name = ?,balance = ?
       WHERE name = ?
       ''',
       [temp1[0]["name"],(temp1[0]["balance"]-amount),temp1[0]["name"]]
      );
    await dbClient.rawUpdate(
       '''
       UPDATE People
       SET name = ?,balance = ?
       WHERE name = ?
       ''',
       [temp2[0]["name"],(temp2[0]["balance"]+amount),temp2[0]["name"]]
      );  
      notifyListeners();
  }
}
