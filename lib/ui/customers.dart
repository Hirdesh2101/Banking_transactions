import 'package:banking_app/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modals.dart';
import './singleperson.dart';
//import '../database.dart';

class Customers extends StatefulWidget {
  static const routeName = '/customers';

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  Future<void>initialize()async{
    await Provider.of<PeopleProvide>(context,listen: false).fetchAndSetPlaces();
  }
    @override
  void initState() {
    initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Customers'),
        ),
        body: new Container(
            padding: new EdgeInsets.all(5.0),
            child: new Consumer<PeopleProvide>(
              builder: (ctx, people, wid) => people.items.length > 0
                  ? ListView.builder(
                      itemCount: people.items.length,
                      itemBuilder: (ctx, i) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/male.jpg'),
                        ),
                        title: Text(people.items[i].name),
                        subtitle: Text(people.items[i].balance.toString()),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              SinglePerson.routeName,
                              arguments: PeopleModal(
                                  name: people.items[i].name,
                                  balance: people.items[i].balance));
                        },
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
              child: Center(
                child: Text('No Data'),
              ),
            )));
  }
}
