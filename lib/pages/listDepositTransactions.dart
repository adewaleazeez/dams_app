import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dams_app/db/damsTable.dart';
import 'package:dams_app/pages/login.dart';
import 'package:dams_app/pages/depositTransaction.dart';
import 'package:dams_app/pages/lineNoScreen.dart';

//void main() => runApp(TransListingScreen());

class Transaction {
  final String sno;
  final String cardno;
  final String name;
  final String amount;

  Transaction({
    this.sno,
    this.cardno,
    this.name,
    this.amount
  }); //this.id,

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      sno: json['sno'],
      cardno: json['cardno'],
      name: json['name'],
      amount: json['amount'],
    );
  }
}

class TransListingScreen extends StatelessWidget {
  final appTitle = 'Transactions Listing';

  final Dams dams;
  TransListingScreen({this.dams});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Center(
              child: JSONListView(title: appTitle, dams: dams)
          ),
        ));
  }
}

class JSONListView extends StatefulWidget {
  final String title;
  final Dams dams;

  JSONListView({Key key, this.title, this.dams}) : super(key: key);

  CustomJSONListView createState() => CustomJSONListView();
}

class CustomJSONListView extends State<JSONListView> {

  //final Dams dams;
  //CustomJSONListView({this.dams});

  //final String url = 'http://192.168.8.104/dadollar/userbackend.php';
  final String url = 'http://154.118.66.217/dadollar/userbackend.php';

  Future<List<Transaction>> fetchJSONData() async {
    var data = {
      'user_option': 'listDepositTrans',
      'user_platform': 'mobile',
      'lineNo': '${widget.dams.lineno}',
      'transDate': '${widget.dams.date}',
      'userName': '${widget.dams.name}'
    };

    var jsonResponse = await http.post(url, body: json.encode(data));

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

      List<Transaction> transactionsList = jsonItems.map<Transaction>((json) {
        return Transaction.fromJson(json);
      }).toList();

      return transactionsList;

    } else {
      print('Failed to load data from internet');
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: fetchJSONData(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          const int $alefsym = 0x2135;
          return ListView(
            children: snapshot.data.map((transaction) => ListTile(
              title: Text(transaction.cardno),
              subtitle: Text(transaction.amount),
              trailing: Text('\u{20A6}'+transaction.name),
              leading: CircleAvatar(
                backgroundColor: (transaction.sno.trim().length == 0  ? Colors.white : Colors.green),
                child: Text(transaction.sno,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )
                ),
              ),
              onTap: () {
                String lineNo = '${widget.dams.lineno}';
                String transDate = '${widget.dams.date}';
                String userName = '${widget.dams.name}';

                final dams = Dams(name: userName, date: transDate, lineno: lineNo);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransListingScreen(dams: dams))
                );
              },
            ),
            )
                .toList(),
          );
        },
      ),

      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('User Name: ${widget.dams.name}'),
              accountEmail: Text("Trans Date: ${widget.dams.date}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text("${widget.dams.name.substring(0,1)}", style: TextStyle(fontSize: 40.0), ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today), title: Text("Enter Line No"),
              onTap: () {
                String lineNo = '${widget.dams.lineno}';
                String transDate = '${widget.dams.date}';
                String userName = '${widget.dams.name}';
                final dams = Dams(name: userName, date: transDate, lineno: lineNo);
                // Navigate to Profile Screen & Sending Email to Next Screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LineNoScreen(dams: dams)),
                );

              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance), title: Text("Deposit Posting"),
              onTap: () {
                //Navigator.pop(context);
                // Navigate to Profile Screen & Sending Email to Next Screen.
                String lineNo = '${widget.dams.lineno}';
                String transDate = '${widget.dams.date}';
                String userName = '${widget.dams.name}';

                final dams = Dams(name: userName, date: transDate, lineno: lineNo);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DepositTransactionScreen(dams: dams))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list), title: Text("Transaction Listing"),
              onTap: () {
                String lineNo = '${widget.dams.lineno}';
                String transDate = '${widget.dams.date}';
                String userName = '${widget.dams.name}';

                final dams = Dams(name: userName, date: transDate, lineno: lineNo);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransListingScreen(dams: dams))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.close), title: Text("Logout"),
              onTap: () {
                // Navigate to Profile Screen & Sending Email to Next Screen.
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginUser())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

