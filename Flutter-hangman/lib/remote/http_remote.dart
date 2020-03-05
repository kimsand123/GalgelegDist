import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hangman/model/user.dart';
import 'package:http/http.dart' as http;

class HttpRemote {
  Future<http.Response> login(User user) {
    // Setup header, url for http call
    Map<String, String> headers = {
      HttpHeaders.acceptEncodingHeader: "application/json",
      HttpHeaders.contentEncodingHeader: "application/json",
    };

    //TODO change to the other server, not directly to auth server
    String url = 'http://dist.saluton.dk:8970/auth/';

    debugPrint('HttpRemote - login starting with body: ${jsonEncode(user)}');
    return http.post(url, headers: headers, body: jsonEncode(user));
  }

  Future<http.Response> playGame(User user) {
    String token = user.token;
    //TODO: use authentication with tokens:
    /*
    final token = 'WIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ikpv';
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    */
  }
}
