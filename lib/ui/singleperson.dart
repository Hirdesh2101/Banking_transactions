import 'package:flutter/material.dart';
import '../modals.dart';
import '../database.dart';
import './transactionHis.dart';
import '../transactiondb.dart';

class SinglePerson extends StatefulWidget {
  static const routeName = '/singlePerson';
  @override
  _SinglePersonState createState() => _SinglePersonState();
}

class _SinglePersonState extends State<SinglePerson> {
  bool _isSelected = false;
  Future<List<PeopleModal>> fetchPeopleFromDatabase(String name) async {
    var dbHelper = DBHelper();
    Future<List<PeopleModal>> people = dbHelper.getTransPeople(name);
    return people;
  }

  @override
  Widget build(BuildContext context) {
    final PeopleModal args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/male.jpg'),
          ),
          Row(
            children: [
              Text('${args.name}'),
              SizedBox(width:5),
              Text('Balance : ${args.balance}')
            ],
          ),
          Row(
            children: [
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(History.routeName,arguments:PeopleModal(args.name,args.balance) );
                },
                child: Text('View Transactions'),
              ),
              RaisedButton(
                child: Text('Make Transaction'),
                onPressed: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
              }),
            ],
          ),
          _isSelected
              ? Container(
                  child: FutureBuilder(
                    future: fetchPeopleFromDatabase(args.name),
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
                                        var dbHelper = DBHelper();
                                        dbHelper.update(args.name, e.name, 10);
                                        var dbHelper2 = DBHelperTran();
                                        dbHelper2.insert(args.name, e.name, 10);
                                        Navigator.of(context).pop();
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/male.jpg'),
                                      ),
                                      title: Text(e.name,
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
                )
              : Container(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
