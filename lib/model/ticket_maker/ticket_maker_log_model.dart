import 'dart:convert';

TicketMakerLog ticketMakerLogFromJson(String str) => TicketMakerLog.fromJson(json.decode(str));
String ticketMakerLogToJson(TicketMakerLog data) => json.encode(data.toJson());

class TicketMakerLog {
  String division;
  DateTime dateTime;
  String userId;
  int quantity;
  String department;
  String category;
  String styleUline;
  int price;
  int printerStatus;
  int handKeyed;

  TicketMakerLog({
    required this.division,
    required this.dateTime,
    required this.userId,
    required this.quantity,
    required this.department,
    required this.category,
    required this.styleUline,
    required this.price,
    required this.printerStatus,
    required this.handKeyed,
  });

  factory TicketMakerLog.fromJson(Map<String, dynamic> json) => TicketMakerLog(
        division: json["division"],
        dateTime: DateTime.parse(json["dateTime"]),
        userId: json["userId"],
        quantity: json["quantity"],
        department: json["department"],
        category: json["category"],
        styleUline: json["styleUline"],
        price: json["price"],
        printerStatus: json["printerStatus"],
        handKeyed: json["handKeyed"],
      );

  Map<String, dynamic> toJson() => {
        "division": division,
        "dateTime": dateTime.toIso8601String(),
        "userId": userId,
        "quantity": quantity,
        "department": department,
        "category": category,
        "styleUline": styleUline,
        "price": price,
        "printerStatus": printerStatus,
        "handKeyed": handKeyed,
      };
}
