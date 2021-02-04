import 'dart:async';
import 'dart:io' as io;
import 'package:banking_app/modals.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelperTran {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "transac.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Trans(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,whom TEXT NOT NULL,amount REAL)");
  }
  Future insert(String name,String whom,var amount)async{
    var dbClient = await db;
    await dbClient.rawInsert( 'INSERT INTO Trans(name,whom,amount) VALUES(?, ?, ?)',
      ['$name','$whom','$amount']);
  }
  Future<List<TransactionModal>> getTran(String name) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Trans WHERE name=?',['$name']);
    List<TransactionModal> people = [];
    for (int i = 0; i < list.length; i++) {
      people.add(new TransactionModal(list[i]["name"],list[i]["whom"],list[i]["amount"]));
    }
    return people;
  }
}