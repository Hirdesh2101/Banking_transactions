import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modals.dart';
import '../database.dart';
import './singleperson.dart';

class Customers extends StatelessWidget {
  static const routeName = '/customers';
  @override
  Widget build(BuildContext context) {
    Future<List<PeopleModal>> fetchPeopleFromDatabase() async {
      var dbHelper = DBHelper();
      Future<List<PeopleModal>> people = dbHelper.getPeople();
      return people;
    }
    return ChangeNotifierProvider(
      create: (context) => DBHelper(),
          child: Scaffold(
        appBar: AppBar(
          title: Text('Customers'),
        ),
        body: new Container(
          padding: new EdgeInsets.all(5.0),
          child: new FutureBuilder<List<PeopleModal>>(
            future: fetchPeopleFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return new Container(
                  alignment: AlignmentDirectional.center,
                  child: new CircularProgressIndicator(),
                );
              } else {
                int len = snapshot.data.length;
                if (len == 0) {
                  return Center(
                    child: Text('No Data Found'),
                  );
                }
                List<PeopleModal> list = snapshot.data.toList();
                return Column(
                  children: [
                    ...list.map((e) {
                      return Column(
                        children: [
                          ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(SinglePerson.routeName,arguments: PeopleModal(e.name,e.balance));
                              },
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/male.jpg'),
                              ),
                              title: Text(e.name,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                              subtitle: Text(e.balance.toString(),
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0))),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
