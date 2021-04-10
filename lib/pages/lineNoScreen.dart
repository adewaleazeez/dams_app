import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dams_app/db/damsTable.dart';
import 'package:dams_app/pages/login.dart';
import 'package:dams_app/pages/depositTransaction.dart';
import 'package:dams_app/pages/listDepositTransactions.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LineNoScreen extends StatelessWidget {

  final appTitle = 'Enter Line No';
  final Dams dams;
  LineNoScreen({this.dams});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,

      //debugShowCheckedModeBanner: false,
      home: MyLineNo(title: appTitle, dams: dams),
    );
  }
}

// ignore: must_be_immutable
class MyLineNo extends StatefulWidget {
  final String title;
  final Dams dams;

  MyLineNo({Key key, this.title, this.dams}) : super(key: key);
  @override
  _MyLineNoState createState() => _MyLineNoState();
}

class _MyLineNoState extends State<MyLineNo> {
  final lineNoController = TextEditingController();
  final transDateController = TextEditingController();
  final userNameController = TextEditingController();

  // SERVER LOGIN API URL
  //final url = 'http://192.168.43.186/dadollar/userbackend.php';
  //final url = 'http://192.168.0.152/dadollar/userbackend.php';
  //final url = 'http://192.168.8.104/dadollar/userbackend.php';
  //final String url = 'http://192.168.8.104/dadollar/userbackend.php';
  final String url = 'http://154.118.66.217/dadollar/userbackend.php';

  bool visible = false ;
  bool showProgressloading = false; // set to false

  Future<void> checkLineNo() async {
    // Showing CircularProgressIndicator.
      setState(() {
        visible = true ;
      });
    // Getting value from Controller
    String lineNo = lineNoController.text;


    // Store all data with Param Name.
    var data = {
      'user_option': 'checkLineNo',
      'user_platform': 'mobile',
      'lineNo': lineNo
    };

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    //var message = jsonDecode(response.body);
    var message = json.decode(response.body);

      setState(() {
        visible = false ;
      });

    // If the Response Message is Matched.
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
                    borderRadius: BorderRadius.circular(16.0),
                ),
                title: Text("Invalid Line No!"),
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
                content: Text("The Line No you entered is not valid.\nClick Ok to try another Line No"),
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

     } else if (message["result"] != "invalidlineno") {

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
                title: Text("Valid Line No!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Text("The Line No you entered ["+message["result"]+"] is valid.\nClick Ok to continue"),
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
    userNameController.text = '${widget.dams.name}';
    transDateController.text = '${widget.dams.date}';
    if('${widget.dams.lineno}' != 'null') {
      lineNoController.text = '${widget.dams.lineno}';
    }

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: ModalProgressHUD(
        inAsyncCall: showProgressloading,
        child: SingleChildScrollView(
          child: Center(

            child: Column(
              children: <Widget>[
                //padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),

                Container(
                  //width: 150.0,
                  //padding: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
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
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Dadollar Accounts Management Systems',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),

                  ),
                ),

                /*Visibility(
                  visible: visible,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator()
                  ),
                ),*/

                Container(
                  width: 320.0,
                  //padding: EdgeInsets.all(10.0),
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: lineNoController,
                    autocorrect: true,
                    decoration: new InputDecoration(
                      hintText: 'Line No',
                      icon: new Icon(
                        Icons.border_color,
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
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
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
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 30.0),
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
                      checkLineNo();
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
                String lineNo = lineNoController.text;
                String transDate = transDateController.text;
                String userName = userNameController.text;

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