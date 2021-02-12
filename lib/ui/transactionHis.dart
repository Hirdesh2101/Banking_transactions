import 'package:flutter/material.dart';
import '../modals.dart';
import '../transactiondb.dart';

class History extends StatelessWidget {
  static const routeName = '/history';
  @override
  Widget build(BuildContext context) {
    final PeopleModal args = ModalRoute.of(context).settings.arguments;
    Future<List<TransactionModal>> fetchPeopleFromDatabase() async {
      var dbHelper = DBHelperTran();
      Future<List<TransactionModal>> people = dbHelper.getTran(args.name);
      return people;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(5.0),
        child: new FutureBuilder<List<TransactionModal>>(
          future: fetchPeopleFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return new Container(
                alignment: AlignmentDirectional.center,
                child: new CircularProgressIndicator(),
              );
            } else {
              int len;
              if (snapshot.hasData) {
                len = snapshot.data.length;
              } else {
                len = 0;
              }
              if (len == 0) {
                print('aya');
                return Center(
                  child: Text('No Transaction Found'),
                );
              }
              List<TransactionModal> list = snapshot.data.toList();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ...list.map((e) {
                      return Column(
                        children: [
                          ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () {},
                              leading: Icon(Icons.history),
                              title: Text('${e.name} --> ${e.whom}'),
                              subtitle: Text(e.amount.toString())),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
