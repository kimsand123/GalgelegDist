// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    String username;
    String alias;

    User({
        this.username,
        this.alias,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["name"],
        alias: json["alias"],
    );

    Map<String, dynamic> toJson() => {
        "name": username,
        "alias": alias,
    };
}
