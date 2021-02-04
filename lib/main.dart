import 'package:banking_app/ui/customers.dart';
import 'package:banking_app/ui/singleperson.dart';
import 'package:banking_app/ui/transactionHis.dart';
import 'package:flutter/material.dart';
import './modals.dart';
import 'dart:async';
import './database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banking System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        Customers.routeName: (ctx) => Customers(),
        SinglePerson.routeName: (ctx) => SinglePerson(),
        History.routeName: (ctx) => History(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<PeopleModal>> fetchEmployeesFromDatabase() async {
    var dbHelper = DBHelper();
    Future<List<PeopleModal>> people = dbHelper.getPeople();
    return people;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(16.0),
          child: RaisedButton(
            child: Text('View People'),
            onPressed: () =>
                Navigator.of(context).pushNamed(Customers.routeName),
          )),
    );
  }
}
