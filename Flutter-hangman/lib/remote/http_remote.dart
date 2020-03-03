import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hangman/model/user.dart';
import 'package:http/http.dart' as http;

class HttpRemote {
  String serverUrl = 'http://dist.saluton.dk:9875';

  Map<String, String> standardHeaders = {
    HttpHeaders.acceptEncodingHeader: "application/json",
    HttpHeaders.contentEncodingHeader: "application/json",
  };

  ///
  /// Login
  /// /auth/logon/
  ///
  Future<http.Response> login(User user) {
    String url = serverUrl + '/auth/logon';

    debugPrint('HttpRemote - login with body: ${jsonEncode(user)}');
    return http.post(url, headers: standardHeaders, body: jsonEncode(user));
  }

  ///
  /// Logoff
  /// /auth/logoff/
  ///
  Future<http.Response> logoff(User user) {
    String url = serverUrl + '/auth/logoff';

    Map<String, String> token = _tokenFromUser(user);

    debugPrint('HttpRemote - logoff with body: $token');
    return http.post(url, headers: standardHeaders, body: jsonEncode(token));
  }

  ///
  /// GuessLetter
  /// /bogstaver/gaet/
  ///
  Future<http.Response> guessLetter(User user, String letter) {
    String url = serverUrl + '/bogstaver/gaet';
    String token = user.token;

    Map<String, dynamic> sendObject = {
      "token": token,
      "letter": letter,
    };

    debugPrint('HttpRemote - guessLetter with body: $sendObject');
    return http.post(url,
        headers: standardHeaders, body: jsonEncode(sendObject));
  }

  ///
  /// usedLetters
  /// /bogstaver/brugte/
  ///
  Future<http.Response> usedLetters(User user) {
    Map<String, String> token = _tokenFromUser(user);

    Uri uri = Uri.http(serverUrl, '/bogstaver/brugte/', token);

    debugPrint('HttpRemote - usedLetters with body: $token');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// numberOfWrongLetters
  /// /bogstaver/antalforkerte/
  ///
  Future<http.Response> numberOfWrongLetters(User user) {
    Map<String, String> token = _tokenFromUser(user);

    Uri uri = Uri.http(serverUrl, '/bogstaver/antalforkerte/', token);

    debugPrint('HttpRemote - numberOfWrongLetters with body: $token');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// wasLastLetterCorrect
  /// /bogstaver/ersidstekorrekt/
  ///
  Future<http.Response> wasLastLetterCorrect(User user) {
    Map<String, String> token = _tokenFromUser(user);

    Uri uri = Uri.http(serverUrl, '/bogstaver/ersidstekorrekt/', token);

    debugPrint('HttpRemote - wasLastLetterCorrect with body: $token');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// word
  /// /ordet/ord/
  ///
  Future<http.Response> word(User user) {
    Map<String, String> token = _tokenFromUser(user);

    Uri uri = Uri.http(serverUrl, '/ordet/ord/', token);

    debugPrint('HttpRemote - word with body: $token');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// visibleWord
  /// /ordet/synligt/
  ///
  Future<http.Response> visibleWord(User user) {
    Map<String, String> token = _tokenFromUser(user);

    Uri uri = Uri.http(serverUrl, '/ordet/synligt/', token);

    debugPrint('HttpRemote - visibleWord with body: $token');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// isGameWon
  /// /spillet/vundet/
  ///
  Future<http.Response> isGameWon(User user) {
    Map<String, String> token = _tokenFromUser(user);

    Uri uri = Uri.http(serverUrl, '/spillet/vundet/', token);

    debugPrint('HttpRemote - isGameWon with body: $token');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// isGameLost
  /// /spillet/tabt/
  ///
  Future<http.Response> isGameLost(User user) {
    Map<String, String> token = _tokenFromUser(user);

    Uri uri = Uri.http(serverUrl, '/spillet/tabt/', token);

    debugPrint('HttpRemote - isGameLost with body: $token');
    return http.get(uri, headers: standardHeaders);
  }

  Map<String, String> _tokenFromUser(User user) {
    return {
      "token": user.token,
    };
  }
}
