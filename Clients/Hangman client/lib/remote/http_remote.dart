import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hangman/model/game.dart';
import 'package:hangman/model/user.dart';
import 'package:http/http.dart' as http;

class HttpRemote {
  String serverUrl = 'dist.saluton.dk:9875';

  Map<String, String> standardHeaders = {
    HttpHeaders.acceptEncodingHeader: "application/json",
    HttpHeaders.contentEncodingHeader: "application/json",
  };

  ///
  /// Login
  /// /auth/logon/
  ///
  Future<http.Response> login(User user) {
    Uri uri = Uri.http(serverUrl, '/auth/logon');

    debugPrint('** HttpRemote - login with body: ${jsonEncode(user)}');
    return http.post(uri, headers: standardHeaders, body: jsonEncode(user));
  }

  ///
  /// Logoff
  /// /auth/logoff/
  ///
  Future<http.Response> logoff(User user) {
    Uri uri = Uri.http(serverUrl, '/auth/logoff');

    Map<String, String> sendMap = _tokenMapFromUser(user);

    debugPrint('** HttpRemote - logoff with body: $sendMap');
    return http.post(uri, headers: standardHeaders, body: jsonEncode(sendMap));
  }

  ///
  /// GuessLetter
  /// /bogstaver/gaet/
  ///
  Future<http.Response> guessLetter(User user, String letter) {
    Uri uri = Uri.http(serverUrl, '/bogstaver/gaet');

    String token = user.token;

    Map<String, dynamic> sendMap = {
      "token": token,
      "letter": letter,
    };

    debugPrint('** HttpRemote - guessLetter with body: $sendMap');

    return http.post(uri, headers: standardHeaders, body: jsonEncode(sendMap));
  }

  ///
  /// usedLetters
  /// /bogstaver/brugte/
  ///
  Future<http.Response> usedLetters(User user) {
    Map<String, String> sendMap = _tokenMapFromUser(user);

    Uri uri = Uri.http(serverUrl, '/bogstaver/brugte/', sendMap);

    debugPrint('-------HttpRemote - usedLetters with body: $sendMap');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// numberOfWrongLetters
  /// /bogstaver/antalforkerte/
  ///
  Future<http.Response> numberOfWrongLetters(User user) {
    Map<String, String> sendMap = _tokenMapFromUser(user);

    Uri uri = Uri.http(serverUrl, '/bogstaver/antalforkerte/', sendMap);

    debugPrint('-------HttpRemote - numberOfWrongLetters with body: $sendMap');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// wasLastLetterCorrect
  /// /bogstaver/ersidstekorrekt/
  ///
  Future<http.Response> wasLastLetterCorrect(User user) {
    Map<String, String> sendMap = _tokenMapFromUser(user);

    Uri uri = Uri.http(serverUrl, '/bogstaver/ersidstekorrekt/', sendMap);

    debugPrint('-------HttpRemote - wasLastLetterCorrect with body: $sendMap');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// word
  /// /ordet/ord/
  ///
  Future<http.Response> word(User user) {
    Map<String, String> sendMap = _tokenMapFromUser(user);

    Uri uri = Uri.http(serverUrl, '/ordet/ord/', sendMap);

    debugPrint('-------HttpRemote - word with body: $sendMap');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// visibleWord
  /// /ordet/synligt/
  ///
  Future<http.Response> visibleWord(User user) {
    Map<String, String> sendMap = _tokenMapFromUser(user);

    Uri uri = Uri.http(serverUrl, '/ordet/synligt/', sendMap);

    debugPrint('-------HttpRemote - visibleWord with body: $sendMap');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// isGameWon
  /// /spillet/vundet/
  ///
  Future<http.Response> isGameWon(User user) {
    Map<String, String> sendMap = _tokenMapFromUser(user);

    Uri uri = Uri.http(serverUrl, '/spillet/vundet/', sendMap);

    debugPrint('-------HttpRemote - isGameWon with body: $sendMap');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// isGameLost
  /// /spillet/tabt/
  ///
  Future<http.Response> isGameLost(User user) {
    Map<String, String> sendMap = _tokenMapFromUser(user);

    Uri uri = Uri.http(serverUrl, '/spillet/tabt/', sendMap);

    debugPrint('-------HttpRemote - isGameLost with body: $sendMap');
    return http.get(uri, headers: standardHeaders);
  }

  ///
  /// resetGame
  /// /spillet/nulstil/
  ///
  Future<http.Response> resetGame(User user) {
    Map<String, String> sendMap = _tokenMapFromUser(user);

    Uri uri = Uri.http(serverUrl, '/spillet/nulstil/');

    debugPrint('** HttpRemote - resetGame with body: $sendMap');
    return http.post(uri, headers: standardHeaders, body: jsonEncode(sendMap));
  }

  Future<Game> getGameData(User user) async {
    Game game = Game();
    game.usedLetters =
        jsonDecode((await usedLetters(user)).body) as List<dynamic>;
    game.numberOfWrongLetters = (await numberOfWrongLetters(user)).body;
    game.wasLastLetterCorrect =
        ((await wasLastLetterCorrect(user)).body == '0' ? false : true);
    game.word = (await word(user)).body;
    game.visibleWord = (await visibleWord(user)).body;
    game.isGameLost = ((await isGameLost(user)).body == '0' ? false : true);
    game.isGameWon = ((await isGameWon(user)).body == '0' ? false : true);

    return game;
  }

  Map<String, String> _tokenMapFromUser(User user) {
    return {
      "token": user.token,
    };
  }
}
