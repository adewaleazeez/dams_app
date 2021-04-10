import 'package:flutter/material.dart';
import 'package:dams_app/pages/login.dart';

void main() => runApp(
    MaterialApp(
      home: MyApp(),
    )
);

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(


            home: Scaffold(
                body: Center(
                    child: LoginUser()
                ),
            ),

            debugShowCheckedModeBanner: false,

            theme: new ThemeData(
                primarySwatch: Colors.blue,
            ),

        );
    }
}
