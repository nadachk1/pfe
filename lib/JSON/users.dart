import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));
String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final int? usrId;
  final String fullName;
  final String email;
  final String usrName;
  final String password;
  final List<String> allergies;

  Users({
    this.usrId,
    required this.fullName,
    required this.email,
    required this.usrName,
    required this.password,
    List<String>? allergies,
  }) : allergies = allergies ?? [];

  // Convertir un Map SQLite en Objet Users
  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        fullName: json["fullName"] ?? "",
        email: json["email"] ?? "",
        usrName: json["usrName"],
        password: json["usrPassword"],
        allergies: (json["allergies"] ?? "").isNotEmpty
            ? json["allergies"].split(',')
            : [],
      );

  // Convertir un Objet Users en Map pour SQLite
  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "fullName": fullName,
        "email": email,
        "usrName": usrName,
        "usrPassword": password,
        "allergies": allergies.isNotEmpty ? allergies.join(',') : "",
      };
}
