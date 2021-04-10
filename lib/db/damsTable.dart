import 'package:dams_app/db/dbhelper.dart';

class Dams {
  //String id;
  String name;
  String date;
  String lineno;

  /*Dams.withoutLineNo(String name, String date) {
    this.name = name;
    this.date = date;
   }

  Dams(String name, String date, String lineno) {
    this.name = name;
    this.date = date;
    this.lineno = lineno;
  }*/
  Dams.nameOnly({this.name});
  Dams.withoutLineNo({this.name, this.date});
  Dams({this.name, this.date, this.lineno});

  Dams.fromMap(Map<String, dynamic> map) {
    //id = map['id'];
    name = map['name'];
    date = map['date'];
    lineno = map['lineno'];
  }

  Map<String, dynamic> toMap() {
    return {
      //DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnDate: date,
      DatabaseHelper.columnLineNo: lineno,
    };
  }
}