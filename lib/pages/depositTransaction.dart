import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dams_app/db/damsTable.dart';
import 'package:dams_app/pages/login.dart';
import 'package:dams_app/pages/lineNoScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dams_app/pages/listDepositTransactions.dart';

class DepositTransactionScreen extends StatelessWidget {

  final appTitle = 'Deposit Posting';
  final Dams dams;
  DepositTransactionScreen({this.dams});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,

      //debugShowCheckedModeBanner: false,
      home: MyDepositTransaction(title: appTitle, dams: dams),
    );
  }
}

// ignore: must_be_immutable
class MyDepositTransaction extends StatefulWidget {
  final String title;
  final Dams dams;

  MyDepositTransaction({Key key, this.title, this.dams}) : super(key: key);
  @override
  _MyDepositTransactionState createState() => _MyDepositTransactionState();
}

class _MyDepositTransactionState extends State<MyDepositTransaction> {
  final cardNoController = TextEditingController();
  final cardNameController = TextEditingController();
  final transAmountController = TextEditingController();
  final lineNoController = TextEditingController();
  final transDateController = TextEditingController();
  final userNameController = TextEditingController();
  bool showProgressloading = false; // set to false

  // SERVER LOGIN API URL
  //final url = 'http://192.168.43.186/dadollar/userbackend.php';
  //final url = 'http://192.168.0.152/dadollar/userbackend.php';
  //final url = 'http://192.168.8.104/dadollar/userbackend.php';
  //final String url = 'http://192.168.8.104/dadollar/userbackend.php';
  final String url = 'http://154.118.66.217/dadollar/userbackend.php';
  final String smsUrl = "http://154.118.66.217/dadollar/sendbulksms.php";

  Future<void> getCustomerName() async {

    String lineNo = lineNoController.text;
    String cardNo = cardNoController.text;
    // Store all data with Param Name.
    var data = {
      'user_option': 'getCustomerName',
      'user_platform': 'mobile',
      'lineNo': lineNo,
      'cardNo' : cardNo
    };

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    //var message = jsonDecode(response.body);
    var message = json.decode(response.body);

    if (message["result"] == "invalidlineno") {
       showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text("Invalid Line No!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      this.setState(() {
                        cardNoController.text = '';
                        cardNoController.clear(); //Clear value
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Text("The Line No you sent is not valid.\nClick Ok and return to Line No Entry page to try another Line No."),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {},
      );

    } else if (message["result"] == "invalidcardno") {
       showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text("Invalid Card No!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      this.setState(() {
                        lineNoController.clear(); //Clear value
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Text("The Card No you entered is not valid.\nClick Ok to try another Card No"),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {},
      );
    } else {
      cardNameController.text = message["result"];
    }
  }

  Future<void> checkDuplicateTrans() async {

    // Getting value from Controller
    String lineNo = lineNoController.text;
    String cardNo = cardNoController.text;
    String cardName = cardNameController.text;
    String transDate = transDateController.text;
    String userName = userNameController.text;
    String depositAmount = transAmountController.text;

    if (cardName == "") {
      showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text("Invalid Card No!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      this.setState(() {
                        cardNoController.clear(); //Clear value
                        cardNameController.clear(); //Clear value
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Text("You must enter a valid Card No."),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {},
      );
    }

    if (double.parse(depositAmount).isNaN) {
      showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text("Invalid Deposit Amount!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      this.setState(() {
                        cardNoController.clear(); //Clear value
                        cardNameController.clear(); //Clear value
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Text("You must enter a Numeric Deposit Amount."),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {},
      );
    }

    // Store all data with Param Name.
    var data = {
      'user_option': 'checkDuplicateTrans',
      'user_platform': 'mobile',
      'lineNo': lineNo,
      'cardNo': cardNo,
      'transDate': transDate,
      'userName': userName,
      'depositAmount': depositAmount
    };

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    //var message = jsonDecode(response.body);
    var message = json.decode(response.body);

    // If the Response Message is Matched.
    if (message["result"] == "duplicateexists") {
      showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text("Duplicate Transaction!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      postDepositTransaction();
                      Navigator.of(context).pop();
                      setState(() {
                        showProgressloading = true;
                      });
                      // stop the Progress indicator after 5 seconds
                      new Future.delayed(const Duration(seconds: 2), () {
                        setState(() => showProgressloading = false);
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      this.setState(() {
                        cardNoController.clear(); //Clear value
                        cardNameController.clear(); //Clear value
                        transAmountController.clear(); //Clear value
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Text("A duplicate transaction already exists.\nPost this transaction anyway?"),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {},
      );

    } else if (message["result"] == "noduplicate") {
      postDepositTransaction();
    }
  }

  Future<void> postDepositTransaction() async {

    // Getting value from Controller
    String lineNo = lineNoController.text;
    String cardNo = cardNoController.text;
    String transDate = transDateController.text;
    String userName = userNameController.text;
    String depositAmount = transAmountController.text;
    cardNoController.text = '';
    cardNameController.text = '';
    transAmountController.text = '';

    // Store all data with Param Name.
    var data = {
      'user_option': 'depositPosting',
      'user_platform': 'mobile',
      'lineNo': lineNo,
      'cardNo': cardNo,
      'transDate': transDate,
      'userName': userName,
      'depositAmount': depositAmount
    };

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    //var message = jsonDecode(response.body);
    var message = json.decode(response.body);

    // If the Response Message is Matched.
    if (message["result"] == "invalidtransaction") {
      showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text("Invalid Transaction!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      this.setState(() {
                        lineNoController.clear(); //Clear value
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Text("The transaction failed, ensure that the transaction amount is numeric and card no is valid."),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {},
      );

    } else if (message["result"] == "successful") {
      showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text("Successful Posting!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      this.setState(() {
                        lineNoController.clear(); //Clear value
                      });

                      var data = {
                        'user_option': 'smstranslist',
                        'user_platform': 'mobile',
                        'lineNo': lineNo,
                        'cardNo' : cardNo,
                        'transdate' : transDate,
                        'username' : userName
                      };

                      // Starting Web API Call.
                      http.post(smsUrl, body: json.encode(data));

                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Text("The transaction is successfully posted."),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    lineNoController.text = '${widget.dams.lineno}';
    transDateController.text = '${widget.dams.date}';
    userNameController.text = '${widget.dams.name}';

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: ModalProgressHUD(
        inAsyncCall: showProgressloading,
        child: SingleChildScrollView(
        child: Center(
            child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/flutter-icon.png'),
                      ),
                    ),
                  ),

                  Container(
                    width: 320.0,
                    //padding: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      controller: cardNoController,
                      autocorrect: true,
                      decoration: new InputDecoration(
                          hintText: 'Card No',
                          icon: new Icon(
                            Icons.border_color,
                            color: Colors.grey,
                          )
                      ),
                      validator: (value) => value.isEmpty ? 'Card No can\'t be empty' : null,
                      //onSaved: (value) => _lineNo = value.trim(),
                    ),
                  ),

                  Container(
                    width: 320.0,
                    //padding: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      controller: transAmountController,
                      autocorrect: true,
                      onTap: () {
                        getCustomerName();
                        setState(() {
                          showProgressloading = true;
                        });
                        // stop the Progress indicator after 5 seconds
                        new Future.delayed(const Duration(seconds: 2), () {
                          setState(() => showProgressloading = false);
                        });
                      },
                      decoration: new InputDecoration(
                          hintText: 'Deposit Amount',
                          icon: new Icon(
                            Icons.border_color,
                            color: Colors.grey,
                          )
                      ),
                      validator: (value) => value.isEmpty ? 'Deposit Amount can\'t be empty' : null,
                      //onSaved: (value) => _lineNo = value.trim(),
                    ),
                  ),

                  Container(
                    width: 320.0,
                    //padding: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      readOnly: true,
                      controller: cardNameController,
                      autocorrect: true,
                      style: TextStyle(fontSize: 22.0, backgroundColor: Colors.lightBlue),
                      decoration: new InputDecoration(
                          hintText: 'Card Name',
                          icon: new Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          )
                      ),
                      //validator: (value) => value.isEmpty ? 'Line No can\'t be empty' : null,
                      //onSaved: (value) => _lineNo = value.trim(),
                    ),
                  ),

                  Container(
                    width: 320.0,
                    //padding: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      readOnly: true,
                      controller: lineNoController,
                      autocorrect: true,
                      style: TextStyle(fontSize: 22.0, backgroundColor: Colors.lightBlue),
                      decoration: new InputDecoration(
                          hintText: '${widget.dams.lineno}',
                          icon: new Icon(
                            Icons.content_paste,
                            color: Colors.grey,
                          )
                      ),
                      //validator: (value) => value.isEmpty ? 'Line No can\'t be empty' : null,
                      //onSaved: (value) => _lineNo = value.trim(),
                    ),
                  ),

                  Container(
                    width: 320.0,
                    //padding: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      readOnly: true,
                      controller: transDateController,
                      autocorrect: true,
                      style: TextStyle(fontSize: 22.0, backgroundColor: Colors.lightBlue),
                      decoration: new InputDecoration(
                        hintText: '${widget.dams.date}',
                        icon: new Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ),
                      ),
                      //validator: (value) => value.isEmpty ? 'Transaction Date can\'t be empty' : null,
                      //onSaved: (value) => _transDate = value.trim(),
                    ),
                  ),

                  Container(
                    width: 320.0,
                    //padding: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 20.0),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      readOnly: true,
                      controller: userNameController,
                      autocorrect: true,
                      style: TextStyle(fontSize: 22.0, backgroundColor: Colors.lightBlue),
                      decoration: new InputDecoration(
                        hintText: '${widget.dams.name}', //'User Name',
                        icon: new Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      //validator: (value) => value.isEmpty ? 'User Name can\'t be empty' : null,
                      //onSaved: (value) => _userName = value.trim(),
                    ),
                  ),

                   Container(
                    width: 320.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      disabledColor: Colors.blue,
                      child: new Text('Submit', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        checkDuplicateTrans();
                        setState(() {
                          showProgressloading = true;
                        });
                        // stop the Progress indicator after 5 seconds
                        new Future.delayed(const Duration(seconds: 3), () {
                          setState(() => showProgressloading = false);
                        });
                      }
                    ),
                  ),

                ]
            ),
          ),
        ),
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
                String transDate = transDateController.text;
                String userName = userNameController.text;
                String lineNo = lineNoController.text;
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
                String lineNo = lineNoController.text;
                String transDate = transDateController.text;
                String userName = userNameController.text;

                final dams = Dams(name: userName, date: transDate, lineno: lineNo);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransListingScreen(dams: dams))
                  //MaterialPageRoute(builder: (context) => MyApp())
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