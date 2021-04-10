class Customer {
  int id;
  String cardname;
  String cardno;

  Customer({this.id, this.cardname, this.cardno});

  factory Customer.fromJson(Map<String, dynamic> parsedJson) {
    return Customer(
      id: parsedJson["id"],
      cardname: parsedJson["cardname"] as String,
      cardno: parsedJson["cardno"] as String,
    );
  }
}