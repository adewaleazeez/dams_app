import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dams_app/pages/lineNoScreen.dart';
import 'package:dams_app/db/damsTable.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginUser extends StatefulWidget {

  LoginUserState createState() => LoginUserState();

}

class LoginUserState extends State {

  // For CircularProgressIndicator.
  bool visible = false ;
  bool showProgressloading = false; // set to false

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // SERVER LOGIN API URL
  //final url = 'http://192.168.43.186/dadollar/userbackend.php';
  //final url = 'http://192.168.0.152/dadollar/userbackend.php';
  //final url = 'http://192.168.8.104/dadollar/userbackend.php';
  //final String url = 'http://192.168.8.104/dadollar/userbackend.php';
  final String url = 'http://154.118.66.217/dadollar/userbackend.php';

  Future userLogin() async{
    //showAlertDialog(context);
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true ;
    });

    // Getting value from Controller
    String username = emailController.text;
    String password = passwordController.text;

    // Store all data with Param Name.
    var data = {'user_option': 'checkLogin', 'user_platform' : 'mobile', 'userName' : username, 'userPassword' : password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    //var message = jsonDecode(response.body);
    var message = json.decode(response.body);

    setState(() {
       visible = false;
    });
    // If the Response Message is Matched.
    if(message["result"] == "changepassword"){
      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Default password detected, You must change your password!"),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if(message["result"] == "inactive"){
      // Showing Alert Dialog with Response JSON Message.
      showDialog(barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("User Name is suspended, contact the Administrator!"),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if(message["result"] == "invalidlogin"){
      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Invalid User Name/Password, please try again!"),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if(message["result"] == "validlogin"){
      // Store all data with Param Name.
      var data = {'user_option': 'getServerDate', 'user_platform' : 'mobile'};

      // Starting Web API Call.
      var response = await http.post(url, body: json.encode(data));

      // Getting Server response into variable.
      var message = json.decode(response.body);

      String serverDate = message["result"];

      final dams = Dams.withoutLineNo(name: username, date: serverDate);
      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LineNoScreen(dams: dams)),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
          title: Text('Dadollar - User Login')),
      body: ModalProgressHUD(
        inAsyncCall: showProgressloading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[

                Container(
                  width: 320.0,
                  //padding: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 48.0,
                      child: Image.asset('assets/flutter-icon.png'),
                    ),
                  ),
                ),

                //Divider(),

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

                 Container(
                  width: 320.0,
                  //padding: EdgeInsets.all(10.0),
                  padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    controller: emailController,
                    decoration: new InputDecoration(
                        hintText: 'User Name',
                        icon: new Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                    validator: (value) =>
                    value.isEmpty
                        ? 'User Name can\'t be empty'
                        : null,
                    //onSaved: (value) => _email = value.trim(),
                  ),
                ),

                Container(
                  width: 320.0,
                  //padding: EdgeInsets.all(10.0),
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 30.0),
                  child: new TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    controller: passwordController,
                    decoration: new InputDecoration(
                        hintText: 'Password',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )),
                    validator: (value) =>
                    value.isEmpty
                        ? 'Password can\'t be empty'
                        : null,
                    //onSaved: (value) => _password = value.trim(),
                  ),
                ),

                Container(
                  width: 320.0,
                  child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Login', style: new TextStyle(
                          fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        userLogin();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

