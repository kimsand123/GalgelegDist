// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String username;
  String password;
  String token;

  User({this.username, this.password, this.token});

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["name"],
        password: json["password"],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        "name": username,
        "password": password,
        'token': this.token,
      };
}
