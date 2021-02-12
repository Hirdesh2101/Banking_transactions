import 'dart:async';
import 'dart:io' as io;
import 'package:banking_app/modals.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
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
        "CREATE TABLE People(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,balance INT)");  
    await insert(db);
  }
  Future insert(Database db)async{
    var dbClient = db;
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Hirdesh',3]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Yogesh',10]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Priyanshu',1]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Manish',100]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Raj',13]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Piyush',0]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Adarsh',1000]);    
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Atul',1]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Chirag',3000]);
    await dbClient.rawInsert( 'INSERT INTO People(name,balance) VALUES(?, ?)',
      ['Dev',8]);  
  }
  Future<List<PeopleModal>> getPeople() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM People');
    List<PeopleModal> people = [];
    for (int i = 0; i < list.length; i++) {
      people.add(new PeopleModal(name: list[i]["name"],balance :list[i]["balance"]));
    }
    return people;
  }
  Future<List<PeopleModal>> getTransPeople(String name) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM People WHERE name!=?',['$name']);
    List<PeopleModal> people = [];
    for (int i = 0; i < list.length; i++) {
      people.add(new PeopleModal(name :list[i]["name"],balance:list[i]["balance"]));
    }
    return people;
  }
  Future<void> update(String name ,String whom , int amount) async {
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
  }
}
